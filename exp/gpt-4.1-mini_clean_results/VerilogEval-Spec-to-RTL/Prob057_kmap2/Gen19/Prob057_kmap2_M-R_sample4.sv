module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// Define minterms where output=1 according to the K-map:
// m0:  a=0 b=0 c=0 d=0
wire m0  = (~a & ~b & ~c & ~d);
// m1:  a=0 b=0 c=0 d=1
wire m1  = (~a & ~b & ~c & d);
// m4:  a=0 b=1 c=0 d=0
wire m4  = (~a & b  & ~c & ~d);
// m8:  a=1 b=0 c=0 d=0
wire m8  = (a  & ~b & ~c & ~d);
// m9:  a=1 b=0 c=0 d=1
wire m9  = (a  & ~b & ~c & d);
// m11: a=1 b=0 c=1 d=1
wire m11 = (a  & ~b & c  & d);
// m12: a=1 b=1 c=0 d=0
wire m12 = (a  & b  & ~c & ~d);
// m13: a=1 b=1 c=0 d=1
wire m13 = (a  & b  & ~c & d);
// m14: a=1 b=1 c=1 d=0
wire m14 = (a  & b  & c  & ~d);
// m15: a=1 b=1 c=1 d=1
wire m15 = (a  & b  & c  & d);

assign out = m0 | m1 | m4 | m8 | m9 | m11 | m12 | m13 | m14 | m15;

endmodule