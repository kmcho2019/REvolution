module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

    reg [31:0] dividend;
    reg [15:0] divisor;
    reg [31:0] temp;
    integer i;

    always @(*) begin
        dividend = {16'b0, A};  // Zero-extend dividend to 32 bits
        divisor = {8'b0, B};    // Zero-extend divisor to 16 bits for comparison

        temp = dividend;
        for (i = 0; i < 16; i = i + 1) begin
            temp = temp << 1;  // Shift left by 1 bit

            // Compare upper 16 bits with divisor
            if (temp[31:16] >= divisor) begin
                temp[31:16] = temp[31:16] - divisor;
                temp[0] = 1'b1;  // Set quotient bit
            end else begin
                temp[0] = 1'b0;  // Clear quotient bit
            end
        end

        // Assign outputs
        result = temp[15:0];  // Quotient is in lower 16 bits
        odd = temp[31:16];    // Remainder is in upper 16 bits
    end

endmodule