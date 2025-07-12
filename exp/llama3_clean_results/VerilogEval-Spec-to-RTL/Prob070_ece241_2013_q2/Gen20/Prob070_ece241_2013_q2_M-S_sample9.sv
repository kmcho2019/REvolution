module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Use a continuous assignment statement for SOP
assign out_sop = (a & b & ~c & d) | (~a & b & c & d) | (a & b & c & d);

// Use a continuous assignment statement for POS
assign out_pos = ~(~a | ~b | ~c | ~d) & ~(a | ~b | ~c | ~d) & ~(a | b | ~c | ~d);

endmodule