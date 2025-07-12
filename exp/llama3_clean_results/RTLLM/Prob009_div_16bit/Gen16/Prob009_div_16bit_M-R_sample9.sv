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

    // Perform division for each bit position
    for (int i = 15; i >= 8; i--) begin
        if ({remainder[7:0], dividend[i]} >= {8'd0, divisor}) begin
            quotient = quotient | (1 << (i-8));
            remainder = {remainder[7:0], dividend[i]} - {8'd0, divisor};
        end else begin
            remainder = {remainder[7:0], dividend[i]};
        end
    end

    // Handle remaining bits
    for (int i = 7; i >= 0; i--) begin
        if ({remainder[7:0]} >= {8'd0, divisor}) begin
            quotient = quotient | (1 << i);
            remainder = {remainder[7:0]} - {8'd0, divisor};
        end
        remainder = {remainder[7:0], 1'b0}; // Shift remainder for next iteration
    end

    result = quotient;
    odd = {8'd0, remainder[7:0]};
end

endmodule