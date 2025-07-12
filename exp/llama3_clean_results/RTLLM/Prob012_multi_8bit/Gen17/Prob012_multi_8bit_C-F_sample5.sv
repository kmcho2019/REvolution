module multi_8bit(
    input   [7:0] A,  // First 8-bit input operand (multiplicand)
    input   [7:0] B,  // Second 8-bit input operand (multiplier)
    output  [15:0] product  // 16-bit output representing the product of A and B
);

    // Primary method: Direct multiplication approach
    assign product = A * B;

    // Optional shift-and-add method for educational purposes or specific design constraints
    // reg [15:0] temp_product;
    // always @(*) begin
    //     temp_product = 0;
    //     for (int i = 0; i < 8; i++) begin
    //         if (B[i] == 1'b1) begin
    //             temp_product = temp_product + (A << i);
    //         end
    //     end
    //     product = temp_product;
    // end

    // For better PPA metrics, consider the following optimizations:
    // 1. Reduce power consumption by minimizing unnecessary switching activity.
    // 2. Optimize timing paths for better performance.
    // 3. Use area-efficient architectures to reduce the overall area usage.

endmodule