module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n
);

    // Directly compute the output using operators
    assign out = (a & b) | (c & d);

    // Compute the inverted output directly from 'out'
    assign out_n = ~out;

endmodule