module div_16bit (
    input  wire [15:0] A, // Dividend
    input  wire [7:0]  B, // Divisor
    output reg  [15:0] result, // Quotient
    output reg  [15:0] odd     // Remainder
);

    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // Register inputs combinationally
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Combinational division logic
    always @(*) begin
        integer i;
        reg [15:0] remainder;
        reg [15:0] quotient;
        reg [7:0]  divisor;
        reg [7:0]  tmp;

        divisor = b_reg;
        remainder = 0;
        quotient = 0;

        // Process from the highest bit down to lowest
        for (i = 15; i >= 0; i = i - 1) begin
            // Shift remainder left by 1 and bring down next bit of dividend
            remainder = {remainder[14:0], a_reg[i]};
            // Compare upper bits of remainder (width of divisor) with divisor
            tmp = remainder[15 -: 8];
            if (tmp >= divisor) begin
                // Subtract divisor from upper bits
                tmp = tmp - divisor;
                // Update remainder upper bits with difference
                remainder[15 -: 8] = tmp;
                // Set quotient bit to 1
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end
        end

        result = quotient;
        odd = remainder;
    end

endmodule