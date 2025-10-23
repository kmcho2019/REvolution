module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Simplified SOP expression based on K-map reduction
assign out_sop = (~a & b & ~c & ~d) | (~a & b & c & d) | (a & b & c & d);

// Simplified POS expression using De Morgan's laws on the complemented SOP
assign out_pos = ~(~a & ~b) & ~(~c & ~d);

endmodule