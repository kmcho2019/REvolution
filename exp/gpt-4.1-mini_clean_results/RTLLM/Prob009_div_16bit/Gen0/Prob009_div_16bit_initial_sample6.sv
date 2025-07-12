module div_16bit(
    input  [15:0] A,
    input  [7:0]  B,
    output reg [15:0] result,
    output reg [15:0] odd
);

    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // Register inputs in combinational always block
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Combinational division logic
    always @(*) begin
        integer i;
        reg [15:0] remainder;
        reg [15:0] quotient;
        reg [15:0] temp;    // to hold shifted remainder + next bit

        quotient = 0;
        remainder = 0;

        // Iterate over each bit of dividend from MSB to LSB
        for (i = 15; i >= 0; i = i - 1) begin
            // Shift remainder left by 1 and bring down next bit of dividend
            remainder = remainder << 1;
            remainder[0] = a_reg[i];

            // Extract top 8 bits of remainder to compare with divisor
            // The bits correspond to remainder[15:8]
            if (remainder[15:8] >= b_reg) begin
                remainder[15:8] = remainder[15:8] - b_reg;
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end
        end

        result = quotient;
        odd = remainder;
    end

endmodule