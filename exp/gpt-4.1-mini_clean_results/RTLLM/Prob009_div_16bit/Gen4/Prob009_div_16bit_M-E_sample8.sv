module div_16bit (
    input  wire [15:0] A,       // 16-bit dividend
    input  wire [7:0]  B,       // 8-bit divisor
    output reg  [15:0] result,  // 16-bit quotient
    output reg  [15:0] odd      // 16-bit remainder (zero-extended)
);

    reg [15:0] a_reg; // hold dividend
    reg [7:0]  b_reg; // hold divisor

    // We'll implement shift-subtract division using a 24-bit register:
    // upper 16 bits: partial remainder area
    // lower 8 bits : remaining dividend bits to be shifted in
    reg [23:0] remainder_dividend; 

    reg [15:0] quotient_temp;
    integer i;

    // Latch inputs combinationally
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    always @(*) begin
        // Initialize combined register:
        // Remainder in upper 16 bits is zero at start
        // Dividend in lower 16 bits
        remainder_dividend = {16'd0, a_reg};

        quotient_temp = 16'd0;

        for (i = 15; i >= 0; i = i - 1) begin
            // Shift left by 1: shift remainder_dividend left by 1 bit
            remainder_dividend = remainder_dividend << 1;

            // Extract the top 16 bits as current remainder candidate
            // Compare with divisor
            if (remainder_dividend[23:8] >= b_reg) begin
                // Subtract divisor from remainder portion
                remainder_dividend[23:8] = remainder_dividend[23:8] - b_reg;
                // Set quotient bit i
                quotient_temp[i] = 1'b1;
            end else begin
                // Quotient bit i is 0
                quotient_temp[i] = 1'b0;
            end
        end

        // Assign outputs
        result = quotient_temp;
        // remainder is the upper 16 bits but only low 8 bits meaningful (since divisor is 8 bits)
        // zero-extend remainder to 16-bit output port
        odd = {8'd0, remainder_dividend[23:16]};
    end

endmodule