module div_16bit (
    input  wire [15:0] A,
    input  wire [7:0]  B,
    output reg  [15:0] result,
    output reg  [15:0] odd
);

    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // Latch inputs into registers combinationally
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Combinational division logic
    always @(*) begin
        reg [7:0] remainder;
        reg [15:0] quotient;
        reg [15:0] partial_dividend;  // Holds remainder concatenated with next dividend bit shifted in
        integer i;

        remainder = a_reg[15:8];   // Initialize remainder to the top 8 bits of dividend
        quotient = 16'b0;

        // Process the remaining 8 bits of the dividend bit by bit
        for (i = 15; i >= 0; i = i - 1) begin
            // partial_dividend = remainder concatenated with next bit of dividend
            // For i=15 down to 8, we use bits from a_reg[15:8] initially in remainder,
            // then bits from a_reg[7:0] in next iterations.
            if (i > 7)
                partial_dividend = {remainder, a_reg[i - 8]};
            else
                partial_dividend = {remainder[6:0], a_reg[i]};

            if (partial_dividend >= b_reg) begin
                quotient[i] = 1'b1;
                remainder = partial_dividend - b_reg;
            end else begin
                quotient[i] = 1'b0;
                remainder = partial_dividend;
            end
        end

        result = quotient;
        odd = {8'b0, remainder};  // Zero-extend remainder to 16 bits
    end

endmodule