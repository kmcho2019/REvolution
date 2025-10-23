module multi_8bit (
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] product
);

    reg [15:0] accumulator;
    reg [15:0] carry;
    reg [7:0] multiplicand;
    reg [7:0] multiplier;
    integer i;

    always @(*) begin
        // Initialize
        accumulator = 16'b0;
        carry = 16'b0;
        multiplicand = A;
        multiplier = B;

        // Bit-serial processing
        for (i = 0; i < 8; i = i + 1) begin
            // Add shifted multiplicand if current bit is set
            if (multiplier[0]) begin
                {carry, accumulator} = accumulator + {8'b0, multiplicand} + carry;
            end

            // Shift operations for next cycle
            multiplicand = multiplicand << 1;
            multiplier = multiplier >> 1;
        end

        // Final addition to resolve carry
        product = accumulator + carry;
    end

endmodule