module multi_8bit(
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] product
);

    always @(*) begin
        product = 16'd0;  // Initialize product to zero
        reg [7:0] temp_A;  // Temporary register for A
        temp_A = A;  // Initialize temp_A with A

        for (int i = 0; i < 8; i++) begin
            if (B[i]) begin  // Check if current bit of B is set
                product = product + (temp_A << i);  // Add temp_A shifted by i bits to product
            end
            // No need to explicitly shift temp_A here, as we're shifting it in the addition operation
        end
    end

endmodule