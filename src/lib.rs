use std::{
    collections::HashMap,
    ffi::{c_char, CStr, CString},
    fmt::Display,
};

#[macro_export]
macro_rules! c_str {
    ($lit:ident) => {
        std::ffi::CString::new($lit).unwrap().into_raw()
    };
}

#[macro_export]
macro_rules! r_str {
    ($lit:expr) => {
        unsafe { std::ffi::CStr::from_ptr($lit).to_str().unwrap() }
    };
}

macro_rules! map(
    { $($key:expr => $value:expr),+ } => {
        {
            let mut m = ::std::collections::HashMap::new();
            $(
                m.insert($key, $value);
            )+
            m
        }
     };
);
#[repr(C)]
#[derive(Debug)]
pub struct gps_data {
    longi: *const c_char,
    lat: *const c_char,
    alt: *const c_char,
    qual: *const c_char,
    head: *const c_char,
    speed: *const c_char,
    gtime: *const c_char,
}

impl gps_data {
    pub fn init() -> Self {
        unsafe {
            gps_data {
                longi: std::mem::zeroed(),
                lat: std::mem::zeroed(),
                alt: std::mem::zeroed(),
                qual: std::mem::zeroed(),
                head: std::mem::zeroed(),
                speed: std::mem::zeroed(),
                gtime: std::mem::zeroed(),
            }
        }
    }
}

impl Display for gps_data {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        // let long =;

        write!(
            f,
            "GPS_DATA: {}
    Longitude: {}
    Latitude: {}
    Altitude: {}
    Quality: {}
    Speed: {}
    Time: {}",
            r_str!(self.head),
            r_str!(self.longi),
            r_str!(self.lat),
            r_str!(self.alt),
            r_str!(self.qual),
            r_str!(self.speed),
            r_str!(self.gtime)
        )
    }
}
/// # Safety
///
/// Calling this function using an invalid buffer *will* probably segfault
#[no_mangle]
#[allow(clippy::not_unsafe_ptr_arg_deref)]
pub extern "C" fn parse_gpgga(buf: *const c_char) -> *const gps_data {
    let data = unsafe { CStr::from_ptr(buf) }
        .to_str()
        .expect("Unable to convert the Cstring to a Rs-String"); // this line segfaults if the pointer is invalid

    let mut gps = gps_data::init();

    data.split(',')
        .enumerate()
        .filter(|(i, key)| !key.is_empty())
        .for_each(|(i, key)| match i + 1 {
            1 => {
                gps.head = {
                    let str = key[1..key.len()].to_string();
                    c_str!(str)
                }
            }
            2 => gps.gtime = c_str!(key),
            3 => gps.lat = c_str!(key),
            4 => unsafe {
                let s = format!("{}{}", CStr::from_ptr(gps.lat).to_str().unwrap(), key);
                gps.lat = c_str!(s);
            },
            5 => gps.longi = c_str!(key),
            6 => unsafe {
                let s = format!("{}{}", CStr::from_ptr(gps.longi).to_str().unwrap(), key);
                gps.longi = c_str!(s);
            },
            7 => gps.qual = c_str!(key),
            10 => gps.alt = c_str!(key),
            8 => gps.speed = c_str!(key),
            _ => (),
        });

    Box::into_raw(Box::new(gps))
}

#[no_mangle]
#[allow(clippy::not_unsafe_ptr_arg_deref)]
pub extern "C" fn print_str(buf: *const gps_data) {
    unsafe {
        println!("{}", *buf);
    }
}
