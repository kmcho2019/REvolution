module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

assign out_sop = (b & c & d) | (~a & ~b & c & ~d);
assign out_pos = (a | b | d) & (a | c | d) & (~a | ~b | c | ~d);

endmodule