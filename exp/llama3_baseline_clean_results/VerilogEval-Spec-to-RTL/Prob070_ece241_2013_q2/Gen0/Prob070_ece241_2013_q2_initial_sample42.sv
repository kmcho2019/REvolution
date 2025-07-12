module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

assign out_sop = (b & c & d) | (a & c & d) | (a & b & c);
assign out_pos = (a | b | c) & (a | b | c | ~d);

endmodule