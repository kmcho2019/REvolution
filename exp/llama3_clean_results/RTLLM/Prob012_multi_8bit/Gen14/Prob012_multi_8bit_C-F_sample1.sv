module multi_8bit(
    input   [7:0] A,  // First 8-bit input operand (multiplicand)
    input   [7:0] B,  // Second 8-bit input operand (multiplier)
    output  [15:0] product  // 16-bit output representing the product of A and B
);

    reg [15:0] temp_product;
    assign product = temp_product;

    always @(*) begin
        temp_product = A * B;
    end

    // Alternatively, we can use the shift-and-add method for manual control
    // reg [15:0] temp_product;
    // assign product = temp_product;

    // always @(*) begin
    //     temp_product = 0;
    //     for (int i = 0; i < 8; i++) begin
    //         if (B[i] == 1'b1) begin
    //             temp_product = temp_product + (A << i);
    //         end
    //     end
    // end

    // To improve performance, we can consider adding pipeline stages to the multiplication operation
    // To reduce power consumption, we can use clock gating to disable the clock signal when the module is not performing useful work
    // To improve area efficiency, we can use resource sharing techniques to reduce the overall area required for the implementation

endmodule