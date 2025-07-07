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

    // Division logic
    always @(*) begin
        integer i;
        reg [15:0] quotient;
        reg [15:0] remainder;
        reg [7:0]  top_bits;
        reg [7:0]  diff;

        quotient = 0;
        remainder = 0;

        // Process each bit from MSB to LSB
        for (i = 15; i >= 0; i = i - 1) begin
            // Shift remainder left by 1 and bring in next bit of dividend
            remainder = {remainder[14:0], a_reg[i]};
            // Extract top 8 bits of remainder to compare with divisor
            top_bits = remainder[15:8];
            if (top_bits >= b_reg) begin
                diff = top_bits - b_reg;
                remainder[15:8] = diff;
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end
        end

        result = quotient;
        odd = remainder;
    end

endmodule