module TopModule(
    input  [2:0] in,  // 3-bit input vector
    output [1:0] out  // 2-bit output vector
);

    // Calculate the population count of the input vector
    assign out = $countones(in);

endmodule