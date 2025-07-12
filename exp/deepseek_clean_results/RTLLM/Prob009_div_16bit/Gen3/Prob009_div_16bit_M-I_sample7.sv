module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [23:0] dividend;  // 16+8 bits sufficient
reg [15:0] divisor;
integer i;

always @(*) begin
    dividend = {8'b0, A};    // Initialize with 8-bit zero extension
    divisor = {8'b0, B};     // Initialize with 8-bit zero extension
    result = 16'b0;          // Initialize quotient

    // Unroll first 2 iterations to reduce critical path
    for (i = 0; i < 16; i = i + 1) begin
        // Shift left the dividend (and current quotient)
        dividend = dividend << 1;
        
        // Subtract divisor from upper bits
        if (dividend[23:16] >= divisor[7:0]) begin
            dividend[23:16] = dividend[23:16] - divisor[7:0];
            result[15-i] = 1'b1;
        end else begin
            result[15-i] = 1'b0;
        end
    end

    // Remainder is in upper 8 bits, zero-extended to 16 bits
    odd = {8'b0, dividend[23:16]};
end

endmodule