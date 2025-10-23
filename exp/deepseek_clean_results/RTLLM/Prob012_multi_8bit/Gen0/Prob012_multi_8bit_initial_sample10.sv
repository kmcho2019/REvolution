module multi_8bit(
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] product
);

    reg [7:0] multiplicand;
    reg [7:0] multiplier;
    integer i;

    always @(*) begin
        product = 16'b0;                // Initialize product to 0
        multiplicand = A;                // Store multiplicand
        multiplier = B;                  // Store multiplier

        for (i = 0; i < 8; i = i + 1) begin
            if (multiplier[i]) begin     // If current bit is set
                product = product + (multiplicand << i);  // Add shifted multiplicand
            end
        end
    end

endmodule