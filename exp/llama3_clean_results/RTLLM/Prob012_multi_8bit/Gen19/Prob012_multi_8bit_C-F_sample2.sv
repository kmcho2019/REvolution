// Module: multi_8bit
// Description: 8-bit multiplier using built-in multiplication operator and optional shift-and-add method
module multi_8bit(
    input   [7:0] A,  // First 8-bit input operand (multiplicand)
    input   [7:0] B,  // Second 8-bit input operand (multiplier)
    output  [15:0] product  // 16-bit output representing the product of A and B
);

    // Primary method: Direct multiplication approach
    // This approach is straightforward and efficient, leveraging the synthesis tool's optimizations
    assign product = A * B;

    // Optional shift-and-add method for educational purposes or specific design constraints
    // This method can be used by commenting out the direct multiplication line above and uncommenting the lines below
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

endmodule

// Example instantiation of the multi_8bit module
module top(
    input   [7:0] A,
    input   [7:0] B,
    output  [15:0] result
);

    // Instantiate the multi_8bit module
    multi_8bit inst_multi_8bit(
        .A(A),  // Input A
        .B(B),  // Input B
        .product(result)  // Output product
    );

endmodule