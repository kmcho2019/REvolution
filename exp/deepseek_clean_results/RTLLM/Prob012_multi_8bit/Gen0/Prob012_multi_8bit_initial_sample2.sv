module multi_8bit (
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
            if (multiplier[0] == 1'b1)   // If LSB of multiplier is 1
                product = product + multiplicand; // Add multiplicand to product
            multiplicand = multiplicand << 1;    // Shift multiplicand left
            multiplier = multiplier >> 1;        // Shift multiplier right
        end
    end

endmodule