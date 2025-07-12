module multi_8bit(
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    assign product = (A * B);

    // Alternatively, the shift-and-add method can be implemented as follows:
    // reg [15:0] product_reg;
    // always @(*) begin
    //     product_reg = 0;
    //     for (int i = 0; i < 8; i++) begin
    //         if (B[i])
    //             product_reg = product_reg + (A << i);
    //     end
    //     product = product_reg;
    // end

endmodule