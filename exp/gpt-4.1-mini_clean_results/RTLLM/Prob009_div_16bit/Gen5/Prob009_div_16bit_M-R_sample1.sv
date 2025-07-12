module div_16bit(
    input  [15:0] A,          // 16-bit dividend
    input  [7:0]  B,          // 8-bit divisor
    output reg [15:0] result, // 16-bit quotient
    output reg [15:0] odd     // 16-bit remainder (upper 8 bits zero)
);

    integer i;
    reg [15:0] quotient_tmp;
    reg [8:0]  remainder_tmp;  // 9 bits to hold remainder concatenated with next bit

    always @(*) begin
        quotient_tmp = 16'd0;
        remainder_tmp = 9'd0; // initial remainder zero

        // Iterate over bits from MSB (15) to LSB (0)
        for (i = 15; i >= 0; i = i - 1) begin
            // Shift remainder left by 1 and append current dividend bit
            remainder_tmp = {remainder_tmp[7:0], A[i]};

            // Compare remainder with divisor (B)
            if (remainder_tmp[8:1] >= B && B != 0) begin
                // Subtract divisor from upper 8 bits of remainder
                remainder_tmp = {1'b0, remainder_tmp[8:1] - B};
                // Set quotient bit i to 1
                quotient_tmp[i] = 1'b1;
            end else begin
                // Quotient bit i is 0 by default, no subtraction
                quotient_tmp[i] = 1'b0;
                // remainder_tmp unchanged except lowest bit already shifted in
            end
        end

        result = quotient_tmp;
        // remainder_tmp[8:1] holds 8-bit remainder after last subtraction
        // zero-extend to 16 bits for output
        odd = {8'd0, remainder_tmp[8:1]};
    end

endmodule