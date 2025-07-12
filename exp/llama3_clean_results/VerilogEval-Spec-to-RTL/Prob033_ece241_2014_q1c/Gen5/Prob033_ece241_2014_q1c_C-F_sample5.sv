module TopModule(
    input  [7:0] a,  // 8-bit 2's complement input number
    input  [7:0] b,  // 8-bit 2's complement input number
    output [7:0] s,  // 8-bit result of the addition
    output      overflow  // indicator of signed overflow
);

    // Perform the addition using the + operator for simplicity and efficiency
    assign s = a + b;

    // Detect signed overflow using a dedicated logic that checks the carry-out
    // This approach is both straightforward and amenable to synthesis optimization
    wire [8:0] sum;
    assign sum = {1'b0, a} + {1'b0, b};
    assign overflow = sum[8];

endmodule