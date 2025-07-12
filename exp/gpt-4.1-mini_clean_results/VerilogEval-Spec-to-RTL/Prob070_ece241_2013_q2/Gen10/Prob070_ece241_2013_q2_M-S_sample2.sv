module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Input vector with a as MSB and d as LSB
wire [3:0] in = {a,b,c,d};

// Minimal SOP for out_sop = 1 for 2,7,15:
// 2  = 0010 = a=0,b=0,c=1,d=0  => ~a & ~b &  c & ~d
// 7  = 0111 = a=0,b=1,c=1,d=1  => ~a &  b &  c &  d
// 15 = 1111 = a=1,b=1,c=1,d=1  =>  a &  b &  c &  d
assign out_sop = 
    (~a & ~b &  c & ~d) |
    (~a &  b &  c &  d) |
    ( a &  b &  c &  d);

// Minimal POS for out_pos covering zeros 0,1,4,5,6,9,10,13,14:
// After simplification:
// out_pos = (a + b + c + d) & (a + ~b + ~c + d) & (~a + b + c + ~d);
assign out_pos = 
    (a |  b |  c |  d) &
    (a | ~b | ~c |  d) &
    (~a |  b |  c | ~d);

endmodule