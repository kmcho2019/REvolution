module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Sum-of-products (SOP) expression directly from the binary representations
assign out_sop = (~a & b & ~c & ~d) | (~a & b & c & d) | (a & b & c & d);

// Product-of-sums (POS) expression derived by considering the complement of the SOP
assign out_pos = ~(~out_sop);

endmodule