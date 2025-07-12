module multi_8bit(
    input   [7:0] A,
    input   [7:0] B,
    output  [15:0] product
);

always_comb
begin
    product = 16'd0; // Initialize product to zero
    for (int i = 0; i < 8; i++) // Iterate through each bit of the multiplier
    begin
        if (B[i] == 1'b1) // Check if the current bit of the multiplier is set
        begin
            product = product + (A << i); // Add the multiplicand to the product at the corresponding shifted position
        end
    end
end

endmodule