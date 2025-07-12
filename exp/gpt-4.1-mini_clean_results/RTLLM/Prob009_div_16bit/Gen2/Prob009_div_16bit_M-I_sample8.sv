module div_16bit(
    input  [15:0] A,         // 16-bit dividend
    input  [7:0]  B,         // 8-bit divisor
    output reg [15:0] result, // 16-bit quotient
    output reg [15:0] odd     // 16-bit remainder
);

    integer i;
    reg [15:0] remainder;
    reg [15:0] quotient;
    reg [23:0] temp; // to hold remainder and next dividend bit concatenated

    always @(*) begin
        quotient = 16'd0;
        remainder = 16'd0;

        // Process bits from MSB (bit 15) to LSB (bit 0)
        for (i = 15; i >= 0; i = i - 1) begin
            // Shift remainder left by 1 and bring in next bit from A
            remainder = {remainder[14:0], A[i]};

            // Extract upper 8 bits of remainder for comparison
            // The "highest bits of dividend" matching divisor width is equivalent to the upper 8 bits of the current remainder
            // Compare these bits with B
            if (remainder[15:8] >= B) begin
                remainder[15:8] = remainder[15:8] - B;
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end
        end

        result = quotient;
        odd = remainder;
    end

endmodule