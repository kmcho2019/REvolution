module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Derive the SOP expression using the correct binary representations
// 2: 0010
// 7: 0111
// 15: 1111
assign out_sop = (~a & b & ~c & ~d) | (~a & b & c & d) | (a & b & c & d);

// Derive the POS expression by inverting the SOP expression
// Since out_pos should be 1 when out_sop is 0, we can directly invert the SOP expression
assign out_pos = ~(~a & b & ~c & ~d | ~a & b & c & d | a & b & c & d);

// Alternative way to think about out_pos, but given the complexity, using the inversion method is more straightforward
// out_pos = ~(~out_sop) can be directly used if out_sop is correctly derived

endmodule