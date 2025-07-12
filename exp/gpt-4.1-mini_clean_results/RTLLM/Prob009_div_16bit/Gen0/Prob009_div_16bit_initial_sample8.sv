module div_16bit (
    input  wire [15:0] A,
    input  wire [7:0]  B,
    output reg  [15:0] result,
    output reg  [15:0] odd
);

    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    always @(*) begin
        // Capture inputs combinationally
        a_reg = A;
        b_reg = B;
    end

    always @(*) begin
        integer i;
        reg [7:0] remainder;
        reg [15:0] quotient;

        remainder = a_reg[15:8];  // Top 8 bits of dividend
        quotient = 0;

        for (i = 7; i >= 0; i = i - 1) begin
            if (remainder >= b_reg) begin
                quotient[i + 8] = 1'b1;
                remainder = remainder - b_reg;
            end else begin
                quotient[i + 8] = 1'b0;
            end
            // Shift next bit of dividend into remainder (lowest bit)
            remainder = {remainder[6:0], a_reg[i]};
        end

        // Final check for remainder >= divisor after last bit
        if (remainder >= b_reg) begin
            quotient[0] = 1'b1;
            remainder = remainder - b_reg;
        end else begin
            quotient[0] = 1'b0;
        end

        result = quotient;
        odd = {8'b0, remainder};  // Place remainder in lower 8 bits, upper bits zero
    end

endmodule