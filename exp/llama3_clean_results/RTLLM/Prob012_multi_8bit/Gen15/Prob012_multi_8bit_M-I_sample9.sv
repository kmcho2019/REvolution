module multi_8bit(
    input   [7:0] A,  // First 8-bit input operand (multiplicand)
    input   [7:0] B,  // Second 8-bit input operand (multiplier)
    output  [15:0] product  // 16-bit output representing the product of A and B
);

    reg [15:0] temp_product;
    assign product = temp_product;

    always @(*) begin
        temp_product = 0;
        for (int i = 0; i < 8; i++) begin
            if (B[i] == 1'b1) begin
                temp_product = temp_product + (A << i);
            end
        end
    end

    // Alternatively, we can use a pipelined shift-and-add method for better performance
    // reg [15:0] temp_product;
    // reg [7:0] shift_A;
    // reg [7:0] shift_B;
    // integer i;

    // always @(*) begin
    //     shift_A = A;
    //     shift_B = B;
    //     temp_product = 0;
    //     for (i = 0; i < 8; i++) begin
    //         if (shift_B[0] == 1'b1) begin
    //             temp_product = temp_product + shift_A;
    //         end
    //         shift_A = shift_A << 1;
    //         shift_B = shift_B >> 1;
    //     end
    // end

endmodule