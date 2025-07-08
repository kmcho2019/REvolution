module div_16bit (
    input  wire [15:0] A,
    input  wire [7:0]  B,
    output reg  [15:0] result,
    output reg  [15:0] odd
);

    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // Register inputs
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Perform combinational division
    always @(*) begin
        integer i;
        reg [15:0] quotient;
        reg [15:0] remainder;
        reg [7:0]  divisor;
        reg [7:0]  rem_high;      // upper bits of remainder to compare with divisor

        quotient = 0;
        remainder = 0;
        divisor = b_reg;

        // Process 16 bits of dividend, one bit per iteration
        for (i = 15; i >= 0; i = i - 1) begin
            // Shift left remainder by 1 and bring down the next highest bit of a_reg
            remainder = remainder << 1;
            remainder[0] = a_reg[i];

            // Extract the upper 8 bits of the remainder for comparison
            rem_high = remainder[15:8];

            // Compare upper 8 bits of remainder with divisor
            if (rem_high >= divisor) begin
                // Set quotient bit
                quotient[i] = 1'b1;

                // Subtract divisor from upper 8 bits of remainder
                remainder[15:8] = rem_high - divisor;
            end else begin
                quotient[i] = 1'b0;
            end
        end

        result = quotient;
        odd = remainder;
    end

endmodule