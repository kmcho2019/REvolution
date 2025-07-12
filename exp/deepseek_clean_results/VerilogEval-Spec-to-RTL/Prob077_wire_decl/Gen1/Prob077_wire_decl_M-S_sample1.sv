module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n
);

    // Combined AND-OR operation
    assign out = (a & b) | (c & d);

    // Inverted output
    assign out_n = ~out;

endmodule