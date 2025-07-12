module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

assign out = 
    (!c &!d & a &!b) |  // cd = 00, ab = 01
    (c &!d & (!a &!b |!a & b)) |  // cd = 01, ab = 00 or 11
    (!c & d & a &!b) |  // cd = 10, ab = 01
    (!c & d &!a &!b) |  // cd = 10, ab = 00
    (c & d & a &!b) |  // cd = 11, ab = 10
    (c & d &!a & b);  // cd = 11, ab = 01

endmodule