module div_16bit (
    input  wire [15:0] A,       // Dividend
    input  wire [7:0]  B,       // Divisor
    output reg  [15:0] result,  // Quotient
    output reg  [15:0] odd      // Remainder (lower 8 bits valid)
);

    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    always @(*) begin
        integer i;
        reg [7:0] rem;           // 8-bit remainder, since divisor is 8-bit
        reg [8:0] rem_sub;       // 9-bit to hold subtraction with borrow

        rem = 8'd0;
        result = 16'd0;

        for (i = 15; i >= 0; i = i - 1) begin
            // Shift remainder left by 1 and bring next dividend bit
            rem = {rem[6:0], a_reg[i]};
            // Subtract divisor if possible
            rem_sub = {1'b0, rem} - {1'b0, b_reg};

            if (!rem_sub[8]) begin
                // No borrow, subtraction valid
                rem = rem_sub[7:0];
                result[i] = 1'b1;
            end else begin
                // Borrow, subtraction not possible
                result[i] = 1'b0;
            end
        end

        odd = {8'd0, rem}; // remainder zero-extended to 16 bits
    end

endmodule