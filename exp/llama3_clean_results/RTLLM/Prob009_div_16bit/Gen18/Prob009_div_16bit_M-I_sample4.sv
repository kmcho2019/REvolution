module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [15:0] quotient;
reg [15:0] remainder;

always @(*) begin
    quotient = 0;
    remainder = 0;

    for (int i = 15; i >= 0; i--) begin
        // Simplified conditional statement
        if (remainder[7:0] >= B) begin
            quotient = quotient | (1 << i);
            // Use a more efficient way to update remainder
            remainder[7:0] = remainder[7:0] - B;
        end
        // Shift remainder and include the next bit of A
        remainder = {A[i], remainder[7:0]};
    end

    result = quotient;
    odd = {8'd0, remainder[7:0]};
end

endmodule