module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n
);

    // Compute both AND conditions
    wire cond1 = a & b;
    wire cond2 = c & d;

    // Direct OR implementation
    assign out = cond1 | cond2;

    // Inverted output
    assign out_n = ~out;

endmodule