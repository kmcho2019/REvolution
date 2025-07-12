module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Minimal SOP implementation
    assign out_sop = (~a & ~b & c & ~d) | (b & c & d);

    // Minimal POS implementation
    assign out_pos = (a | b | c) & (a | ~b | c) & (~a | b | d) & (~a | ~b | c);

endmodule