module TopModule (
    input  a,      // MSB
    input  b,
    input  c,
    input  d,      // LSB
    output out_sop,
    output out_pos
);

wire [3:0] in_vec = {a,b,c,d};

// Minimal SOP derived considering don't cares at 3,8,11,12:
// Function is 1 for 2(0010),7(0111),15(1111)
// 2 = 0 0 1 0
// 7 = 0 1 1 1
// 15= 1 1 1 1
// Covering terms:
// - (b & c & d) covers 7 and 15
// - (~a & ~b & c & ~d) covers 2
assign out_sop = (b & c & d) | (~a & ~b & c & ~d);

// Minimal POS considering don't cares, function is 0 for 0,1,4,5,6,9,10,13,14
// POS terms from zeros (excluding don't cares):
// (a + b + ~c + d) & (~a + b + c + d)
assign out_pos = (a | b | ~c | d) & (~a | b | c | d);

endmodule