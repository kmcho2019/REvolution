module multi_8bit(
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

reg [15:0] product_reg;

always @(A or B) begin
    product_reg = 0; // Initialize product to zero
    reg [7:0] A_reg = A; // Temporary register for multiplicand
    reg [7:0] B_reg = B; // Temporary register for multiplier
    reg [2:0] i; // Loop counter

    for (i = 0; i < 8; i = i + 1) begin
        if (B_reg[0]) begin // Check if current bit of multiplier is set
            product_reg = product_reg + {8'd0, A_reg}; // Add multiplicand to product
        end
        A_reg = A_reg << 1; // Shift multiplicand left by one bit
        B_reg = B_reg >> 1; // Shift multiplier right by one bit
    end

    product = product_reg; // Assign final product to output
end

endmodule