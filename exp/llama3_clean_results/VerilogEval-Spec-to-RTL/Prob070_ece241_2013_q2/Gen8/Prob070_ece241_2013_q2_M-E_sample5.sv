module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out_sop,
    output reg out_pos
);

// Derivation of SOP expression using K-maps
assign out_sop = (b & ~c & ~d) | (~a & b & c & d) | (a & b & c & d);

// Derivation of POS expression using K-maps
assign out_pos = ~( (~a & ~b & ~c & ~d) | (~a & ~b & c & ~d) | (~a & ~b & ~c & d) | (~a & b & ~c & ~d) | (~a & ~b & c & d) | (~a & b & ~c & d) | (a & ~b & ~c & ~d) | (a & ~b & c & ~d) | (a & ~b & ~c & d) );

endmodule