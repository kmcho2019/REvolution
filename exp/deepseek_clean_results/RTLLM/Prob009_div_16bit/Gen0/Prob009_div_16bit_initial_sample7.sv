module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [31:0] dividend;
reg [15:0] divisor;
reg [31:0] diff;
integer i;

always @(*) begin
    dividend = {16'b0, A};  // Initialize dividend (A) with 16-bit zero extension
    divisor = {8'b0, B};    // Initialize divisor (B) with 8-bit zero extension
    result = 16'b0;         // Initialize quotient to 0

    for (i = 0; i < 16; i = i + 1) begin
        // Shift left the dividend (and current quotient)
        dividend = dividend << 1;
        
        // Subtract divisor from upper bits
        diff = {dividend[31:16], 16'b0} - {divisor, 16'b0};
        
        if (!diff[31]) begin  // If result is non-negative
            dividend[31:16] = diff[31:16];  // Update remainder
            result[15-i] = 1'b1;           // Set quotient bit
        end
        else begin
            result[15-i] = 1'b0;            // Quotient bit remains 0
        end
    end

    odd = dividend[31:16];  // Remainder is in upper 16 bits
end

endmodule