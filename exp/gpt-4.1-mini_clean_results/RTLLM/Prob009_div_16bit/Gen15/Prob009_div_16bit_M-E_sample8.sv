module div_16bit (
    input  wire [15:0] A,      // Dividend
    input  wire [7:0]  B,      // Divisor
    output reg  [15:0] result, // Quotient
    output reg  [15:0] odd     // Remainder (lower 8 bits valid)
);

    integer i;
    reg [8:0] remainder;  // 9-bit to hold possible borrow (1 extra bit)
    reg [15:0] quotient;

    always @(*) begin
        remainder = 9'd0;
        quotient = 16'd0;

        // Process dividend bits from MSB to LSB
        for (i = 15; i >= 0; i = i - 1) begin
            remainder = {remainder[7:0], A[i]}; // Shift left remainder by 1, insert dividend bit

            // Compare remainder with divisor (extend divisor to 9 bits to match remainder)
            if (remainder >= {1'b0, B}) begin
                remainder = remainder - {1'b0, B};
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end
        end

        result = quotient;
        odd = {8'd0, remainder[7:0]}; // zero extend remainder to 16 bits
    end

endmodule