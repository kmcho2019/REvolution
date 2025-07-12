module multi_8bit(
    input   [7:0] A,  // First 8-bit input operand (multiplicand)
    input   [7:0] B,  // Second 8-bit input operand (multiplier)
    output  [15:0] product  // 16-bit output representing the product of A and B
);

    // Primary method: Direct multiplication approach for simplicity and efficiency
    assign product = A * B;

    // Optional shift-and-add method for educational purposes or specific design constraints
    // This method can be optimized for better PPA metrics by considering the specific technology and design constraints
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

    // To improve PPA metrics, consider the following:
    // 1. Apply synthesis directives to optimize for power and area.
    // 2. Utilize dedicated multiplier blocks if available in the target technology.
    // 3. Optimize the combinational logic for area and power.

endmodule