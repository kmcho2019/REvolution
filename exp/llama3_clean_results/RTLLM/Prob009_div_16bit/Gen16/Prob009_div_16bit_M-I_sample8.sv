module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [15:0] dividend;
reg [7:0] divisor;
reg [15:0] quotient;
reg [15:0] remainder;

always @(*) begin
    dividend = A;
    divisor = B;
    quotient = 0;
    remainder = 0;

    for (int i = 15; i >= 8; i--) begin
        // Compare the higher bits of the dividend with the divisor
        if ({dividend[15:8], 8'd0} >= {8'd0, divisor}) begin
            // Update the quotient and remainder
            quotient = quotient | (1 << (i - 8));
            remainder = {dividend[15:8], 8'd0} - {8'd0, divisor};
        end else begin
            remainder = {dividend[15:8], 8'd0};
        end

        // Shift the dividend and remainder
        dividend = {dividend[7:0], 8'd0};
    end

    // Process the remaining bits
    for (int i = 7; i >= 0; i--) begin
        // Compare the remainder with the divisor
        if ({remainder[7:0], dividend[i]} >= {8'd0, divisor}) begin
            // Update the quotient and remainder
            quotient = quotient | (1 << i);
            remainder = {remainder[7:0], dividend[i]} - {8'd0, divisor};
        end else begin
            remainder = {remainder[7:0], dividend[i]};
        end
    end

    result = quotient;
    odd = {8'd0, remainder[7:0]};
end

endmodule