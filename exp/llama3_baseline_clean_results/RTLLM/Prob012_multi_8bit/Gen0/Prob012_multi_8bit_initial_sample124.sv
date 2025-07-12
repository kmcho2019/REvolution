module multi_8bit(
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

reg [15:0] product_reg; // internal register for product

always @(A or B) begin
    product_reg = 16'd0; // initialize product to 0
    reg [7:0] A_reg; // internal register for A
    A_reg = A; // initialize A_reg with A
    
    // iterate through each bit of B
    for (int i = 0; i < 8; i++) begin
        // check if current bit of B is set
        if (B[i]) begin
            // add shifted A to product
            product_reg = product_reg + (A_reg << i);
        end
        // shift A left for next iteration
        A_reg = A_reg << 1;
    end
    product = product_reg; // assign final product
end

endmodule