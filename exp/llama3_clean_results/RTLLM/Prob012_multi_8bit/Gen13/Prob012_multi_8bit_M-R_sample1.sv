module multi_8bit(
    input   [7:0] A,  // First 8-bit input operand (multiplicand)
    input   [7:0] B,  // Second 8-bit input operand (multiplier)
    output  [15:0] product  // 16-bit output representing the product of A and B
);

    // Initialize product
    reg [15:0] prod;
    assign prod = {16{1'b0}};
    
    // Perform shift-and-add for each bit of B
    reg [15:0] temp;
    always @(*) begin
        temp = 16'd0;
        for (int i = 0; i < 8; i++) begin
            if (B[i]) begin
                temp = temp + (A << i);
            end
        end
        product = temp;
    end

endmodule