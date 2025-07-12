module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n
);

    // Directly connect AND gate outputs to OR gate
    assign out = (a & b) | (c & d);
    assign out_n = ~out;

endmodule