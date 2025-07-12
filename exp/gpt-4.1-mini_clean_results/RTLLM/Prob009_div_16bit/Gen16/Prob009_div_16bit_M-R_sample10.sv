module div_16bit (
    input  wire [15:0] A,       // Dividend
    input  wire [7:0]  B,       // Divisor
    output reg  [15:0] result,  // Quotient
    output reg  [15:0] odd      // Remainder (lower 8 bits valid)
);

    always @(*) begin
        // Local variables for remainder and quotient computation
        reg [8:0] rem;        // 9-bit remainder to accommodate borrow
        reg [15:0] quotient;
        integer i;

        rem = 9'd0;
        quotient = 16'd0;

        for (i = 15; i >= 0; i = i - 1) begin
            // Shift remainder left by 1 and bring in next dividend bit
            rem = {rem[7:0], A[i]};
            // If remainder >= divisor, subtract divisor and set quotient bit
            if (rem >= {1'b0, B}) begin
                rem = rem - {1'b0, B};
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end
        end

        // Assign outputs
        result = quotient;
        odd = {8'd0, rem[7:0]};  // zero-extend remainder to 16 bits
    end

endmodule