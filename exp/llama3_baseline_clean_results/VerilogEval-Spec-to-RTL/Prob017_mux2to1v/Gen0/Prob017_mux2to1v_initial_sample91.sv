module TopModule(
    input  [99:0] a,  // 100-bit input vector
    input  [99:0] b,  // 100-bit input vector
    input         sel,  // 1-bit select signal
    output [99:0] out  // 100-bit output vector
);

    // Use a conditional operator to select between 'a' and 'b' based on 'sel'
    assign out = sel ? b : a;

endmodule