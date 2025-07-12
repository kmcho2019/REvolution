module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

wire [3:0] in;
assign in = {a,b,c,d};

// Minimal Sum-of-Products from minterms for 2,7,15:
// 2  = 4'b0010
// 7  = 4'b0111
// 15 = 4'b1111
assign out_sop = (in == 4'd2) | (in == 4'd7) | (in == 4'd15);

// Minimal Product-of-Sums equivalent:
// out_pos = (c + d) & (b + c + ~a)
// Implemented carefully using inputs
assign out_pos = (c | d) & (b | c | ~a);

endmodule