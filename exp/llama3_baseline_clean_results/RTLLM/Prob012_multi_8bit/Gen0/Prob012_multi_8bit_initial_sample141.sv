module multi_8bit(
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    assign product = (A * B);

    // The above line is the most straightforward implementation of an 8-bit multiplier.
    // However, if you want to explicitly implement the shift-and-add method for educational purposes:

    // wire [15:0] product;
    // assign product = (A * B);

    // reg [15:0] temp_product;
    // always @(*) begin
    //     temp_product = 0;
    //     reg [7:0] temp_A;
    //     temp_A = A;
    //     for (reg [2:0] i = 0; i < 8; i = i + 1) begin
    //         if (B[i] == 1) begin
    //             temp_product = temp_product + (temp_A << i);
    //         end
    //     end
    //     product = temp_product;
    // end

    // The following is an alternative explicit implementation using always block and for loop
    // reg [15:0] product_reg;
    // always @(*) begin
    //     product_reg = 0;
    //     reg [7:0] A_reg;
    //     A_reg = A;
    //     for (reg [2:0] i = 0; i < 8; i = i + 1) begin
    //         if (B[i] == 1'b1) begin
    //             product_reg = product_reg + (A_reg << i);
    //         end
    //         if (i < 7) begin
    //             A_reg = A_reg << 1;
    //         end
    //     end
    //     product = product_reg;
    // end

endmodule