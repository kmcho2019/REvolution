module multi_8bit(
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

reg [15:0] product;

always @(A or B) begin
    product = 0;
    reg [7:0] temp_A = A; // Temporary variable to hold A
    for (int i = 0; i < 8; i++) begin
        if (B[i]) begin
            product = product + (temp_A << i);
        end
        // No need to explicitly shift temp_A here as it's used in the next iteration with the shift operation
    end
end

endmodule