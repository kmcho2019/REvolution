module multi_8bit (
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] product
);

    reg [15:0] multiplicand;
    reg [7:0] multiplier;
    reg [15:0] sum;
    reg [15:0] carry;
    integer i;

    always @(*) begin
        // Initialize
        multiplicand = {8'b0, A};
        multiplier = B;
        sum = 16'b0;
        carry = 16'b0;

        // Bit-serial processing
        for (i = 0; i < 8; i = i + 1) begin
            // Add shifted multiplicand if multiplier bit is set
            if (multiplier[0]) begin
                {carry, sum} = sum + carry + multiplicand;
            end

            // Prepare for next bit
            multiplicand = multiplicand << 1;
            multiplier = multiplier >> 1;
        end

        // Final addition to resolve carry-save form
        product = sum + carry;
    end

endmodule