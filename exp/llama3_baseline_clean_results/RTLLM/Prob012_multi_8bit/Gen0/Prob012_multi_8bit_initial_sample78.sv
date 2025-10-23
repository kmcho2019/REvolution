module multi_8bit(
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    assign product = (A * B);

    // The above line can also be implemented using always block and for loop as shown below:
    // reg [15:0] temp_product;
    // always @(*) begin
    //     temp_product = 0;
    //     for (int i = 0; i < 8; i++) begin
    //         if (B[i])
    //             temp_product = temp_product + (A << i);
    //     end
    //     product = temp_product;
    // end

endmodule