module div_16bit (
    input  wire [15:0] A,      // 16-bit dividend
    input  wire [7:0]  B,      // 8-bit divisor
    output reg  [15:0] result, // 16-bit quotient
    output reg  [15:0] odd     // 16-bit remainder
);

    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // First combinational block: latch inputs
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Second combinational block: perform division using iterative extraction and concatenation
    always @(*) begin
        reg [15:0] quotient;
        reg [15:0] remainder; // will hold extended remainder bits at each iteration
        reg [7:0]  extracted;
        integer i;

        quotient = 16'b0;
        remainder = 16'b0;

        // temp_dividend initially is the 16-bit input dividend
        reg [15:0] temp_dividend;
        temp_dividend = a_reg;

        // Start division: at each step extract top 8 bits of temp_dividend,
        // compare with divisor, set quotient bit, and update remainder and temp_dividend.
        for (i = 15; i >= 0; i = i - 1) begin
            // Extract top 8 bits from temp_dividend starting at MSB
            extracted = temp_dividend[15:8];

            // Compare extracted with divisor b_reg
            if (extracted >= b_reg) begin
                // Quotient bit set
                quotient[i] = 1'b1;

                // Calculate remainder bits: difference between extracted and divisor
                remainder[15:8] = extracted - b_reg;
            end else begin
                quotient[i] = 1'b0;

                // Remainder is extracted unchanged
                remainder[15:8] = extracted;
            end

            // Concatenate remainder with next highest dividend bit:
            // Shift remainder left by 1 to make room for next dividend bit (bit 7 of temp_dividend)
            // Next highest dividend bit is bit 7 of temp_dividend (next lower block)
            // So shift remainder[15:8] left by 1 and insert temp_dividend[7] at LSB of remainder[8]
            remainder = {remainder[14:8], temp_dividend[7], remainder[7:0]};

            // Shift temp_dividend left by 1 to drop top bit processed and bring next bit in MSB
            temp_dividend = {temp_dividend[14:0], 1'b0};
        end

        result = quotient;
        odd = remainder;
    end

endmodule