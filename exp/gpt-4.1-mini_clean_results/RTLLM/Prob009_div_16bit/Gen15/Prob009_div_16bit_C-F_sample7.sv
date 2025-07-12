module div_16bit (
    input  wire [15:0] A,       // Dividend
    input  wire [7:0]  B,       // Divisor
    output reg  [15:0] result,  // Quotient
    output reg  [15:0] odd      // Remainder (lower 8 bits valid)
);

    // Registers to hold inputs combinationally (first always block)
    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Second always block: combinational division logic
    reg [8:0] rem_stage [0:16];  // 9-bit remainder stages
    reg [15:0] quotient_bits;     // Quotient bits

    integer i;
    always @(*) begin
        rem_stage[0] = 9'd0;
        for (i = 0; i < 16; i = i + 1) begin
            // Shift remainder left by 1 and bring in next dividend bit
            reg [8:0] rem_shift;
            reg [8:0] rem_sub;
            reg       bit_set;

            rem_shift = {rem_stage[i][7:0], a_reg[15 - i]};
            // Compare and subtract if possible
            if (rem_shift >= {1'b0, b_reg}) begin
                rem_sub = rem_shift - {1'b0, b_reg};
                bit_set = 1'b1;
            end else begin
                rem_sub = rem_shift;
                bit_set = 1'b0;
            end

            rem_stage[i+1] = rem_sub;
            quotient_bits[15 - i] = bit_set;
        end

        result = quotient_bits;
        // zero-extend remainder to 16 bits (lower 8 bits valid)
        odd = {8'd0, rem_stage[16][7:0]};
    end

endmodule