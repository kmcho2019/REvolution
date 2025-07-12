module multi_8bit(
    input [7:0] A,  // First 8-bit input operand (multiplicand)
    input [7:0] B,  // Second 8-bit input operand (multiplier)
    output [15:0] product  // 16-bit output representing the product of A and B
);

    // Define the basic processing element (PE) for the systolic array
    module PE(
        input [7:0] multiplicand,
        input [15:0] partial_product_in,
        input bit multiplier_bit,
        output [15:0] partial_product_out
    );
        wire [15:0] multiplied;
        assign multiplied = (multiplier_bit == 1'b1) ? {8'b0, multiplicand} : 16'b0;
        assign partial_product_out = partial_product_in + multiplied;
    endmodule

    // Instantiate the systolic array with 8 rows
    wire [15:0] row0_out, row1_out, row2_out, row3_out, row4_out, row5_out, row6_out, row7_out;
    PE row0(.multiplicand(A), .partial_product_in(16'b0), .multiplier_bit(B[0]), .partial_product_out(row0_out));
    PE row1(.multiplicand(A), .partial_product_in(row0_out), .multiplier_bit(B[1]), .partial_product_out(row1_out));
    PE row2(.multiplicand(A), .partial_product_in(row1_out), .multiplier_bit(B[2]), .partial_product_out(row2_out));
    PE row3(.multiplicand(A), .partial_product_in(row2_out), .multiplier_bit(B[3]), .partial_product_out(row3_out));
    PE row4(.multiplicand(A), .partial_product_in(row3_out), .multiplier_bit(B[4]), .partial_product_out(row4_out));
    PE row5(.multiplicand(A), .partial_product_in(row4_out), .multiplier_bit(B[5]), .partial_product_out(row5_out));
    PE row6(.multiplicand(A), .partial_product_in(row5_out), .multiplier_bit(B[6]), .partial_product_out(row6_out));
    PE row7(.multiplicand(A), .partial_product_in(row6_out), .multiplier_bit(B[7]), .partial_product_out(row7_out));

    // The final product is the output of the last row
    assign product = row7_out;

endmodule