module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n
);

    // Compute AND terms
    wire ab = a & b;
    wire cd = c & d;

    // Implement OR function using MUX-like structure
    assign out = ab | cd;

    // Inverted output
    assign out_n = ~out;

endmodule