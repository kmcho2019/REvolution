module div_16bit (
    input  wire [15:0] A,       // Dividend
    input  wire [7:0]  B,       // Divisor
    output reg  [15:0] result,  // Quotient
    output reg  [15:0] odd      // Remainder (lower 8 bits valid)
);

    // Internal registers to hold inputs combinationally
    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // First always block: update internal registers on any input change (combinational)
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Intermediate signals for division pipeline
    reg [8:0] rem [0:16];        // 9-bit remainder stages: rem[0] to rem[16]
    reg [15:0] quot_bits;        // Quotient bits vector

    integer i;

    // Second always block: combinational division logic triggered by input registers change
    always @(*) begin
        // Initialize remainder at stage 0 to zero
        rem[0] = 9'd0;

        // Iterative division steps
        for (i = 0; i < 16; i = i + 1) begin
            // Shift left remainder by 1, bring down the next MSB bit of the dividend
            // Note: a_reg[15 - i] is the current dividend bit (MSB first)
            rem[i+1] = {rem[i][7:0], a_reg[15 - i]};
            // Compare and subtract if possible
            if (rem[i+1] >= {1'b0, b_reg}) begin
                rem[i+1] = rem[i+1] - {1'b0, b_reg};
                quot_bits[15 - i] = 1'b1;
            end else begin
                quot_bits[15 - i] = 1'b0;
            end
        end

        // Assign outputs: quotient and zero-extended remainder
        result = quot_bits;
        odd = {8'd0, rem[16][7:0]}; // remainder is lower 8 bits padded with zeros
    end

endmodule