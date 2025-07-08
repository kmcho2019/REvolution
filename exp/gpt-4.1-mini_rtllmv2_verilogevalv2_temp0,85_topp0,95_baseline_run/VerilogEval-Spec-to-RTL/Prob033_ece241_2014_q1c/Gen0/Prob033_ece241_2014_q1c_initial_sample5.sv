module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    wire [8:0] sum;

    assign sum = {1'b0, a} + {1'b0, b};
    assign s = sum[7:0];
    // Overflow occurs if sign bit carry in != carry out
    // Extract carry into MSB (bit 7) and carry out (bit 8)
    assign overflow = (sum[7] ^ sum[8]);

endmodule