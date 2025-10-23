module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

    reg [23:0] temp;  // 16-bit remainder + 8-bit divisor space
    reg [15:0] quotient;
    integer i;

    always @(*) begin
        temp = {8'b0, A};  // Only need 8-bit zero extension
        quotient = 16'b0;

        for (i = 0; i < 16; i = i + 1) begin
            // Shift left the temp and quotient
            temp = temp << 1;
            quotient = quotient << 1;

            // Compare only the upper 8 bits with divisor
            if (temp[23:16] >= B) begin
                temp[23:16] = temp[23:16] - B;
                quotient[0] = 1'b1;  // Set LSB of quotient
            end
            // else quotient[0] remains 0 from the shift
        end

        // Assign outputs
        result = quotient;
        odd = {8'b0, temp[23:16]};  // Zero-extend remainder to 16 bits
    end

endmodule