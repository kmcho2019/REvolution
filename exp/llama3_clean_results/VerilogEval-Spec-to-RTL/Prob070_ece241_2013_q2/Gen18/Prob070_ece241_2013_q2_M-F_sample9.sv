module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Corrected implementation for SOP
assign out_sop = (~a & b & ~c & ~d) | (~a & b & c & d) | (a & b & c & d);

// Corrected implementation for POS
// Using a Karnaugh map or applying Boolean algebra rules to simplify the expression
assign out_pos = (a | ~b) & (a | ~c) & (a | ~d) & (b | ~c) & (b | ~d) & (c | ~d);

endmodule