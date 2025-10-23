module TopModule (
    input  a,      // MSB
    input  b,
    input  c,
    input  d,      // LSB
    output out_sop,
    output out_pos
);

// Minimal SOP expression for outputs 1 at 2,7,15
assign out_sop = (b & c & d) | (~a & ~b & c & ~d);

// Minimal POS expression for outputs 0 at specified zeros
assign out_pos = (a | b | ~c | d) & (~a | b | c | d);

endmodule