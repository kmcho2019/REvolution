module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Minimal Sum-of-products implementation
    // Using don't-care conditions for optimization
    assign out_sop = (~a & c) | (b & c & d);

    // Minimal Product-of-sums implementation
    // Using don't-care conditions for optimization
    assign out_pos = (a | c) & (b | c | d) & (~b | ~c | ~d);

endmodule