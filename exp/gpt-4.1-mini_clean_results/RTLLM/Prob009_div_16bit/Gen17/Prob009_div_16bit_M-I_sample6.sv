module div_16bit (
    input  wire [15:0] A,       // Dividend
    input  wire [7:0]  B,       // Divisor
    output reg  [15:0] result,  // Quotient
    output reg  [15:0] odd      // Remainder (lower 8 bits valid)
);

    // Second always block: combinational division logic directly using inputs
    reg [7:0] rem;              // 8-bit remainder
    reg       rem_carry;        // Carry bit representing 9th bit of remainder
    reg [15:0] quotient_bits;   // Quotient bits

    integer i;
    reg [8:0] rem_shift;        // 9-bit remainder with next dividend bit

    always @(*) begin
        rem = 8'd0;
        rem_carry = 1'b0;
        quotient_bits = 16'd0;

        for (i = 0; i < 16; i = i + 1) begin
            // Combine carry and remainder into 9-bit value, shift left by 1, and bring in next dividend bit
            rem_shift = {rem_carry, rem, A[15 - i]};

            if (rem_shift >= {1'b0, B}) begin
                rem_shift = rem_shift - {1'b0, B};
                quotient_bits[15 - i] = 1'b1;
            end else begin
                quotient_bits[15 - i] = 1'b0;
            end

            // Update remainder and carry from rem_shift
            rem_carry = rem_shift[8];
            rem = rem_shift[7:0];
        end

        result = quotient_bits;
        // zero-extend remainder to 16 bits (lower 8 bits valid)
        odd = {8'd0, rem};
    end

endmodule