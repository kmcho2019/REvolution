module div_16bit (
    input  wire [15:0] A,       // Dividend
    input  wire [7:0]  B,       // Divisor
    output reg  [15:0] result,  // Quotient
    output reg  [15:0] odd      // Remainder (lower 8 bits valid)
);

    reg [15:0] a_reg;   // Registered dividend
    reg [7:0]  b_reg;   // Registered divisor

    integer i;
    reg [8:0] rem;        // 9-bit remainder (8-bit remainder shifted left + next bit)
    reg [15:0] quotient;  // 16-bit quotient

    // First always block: Register inputs (combinational)
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Second always block: Division logic (combinational)
    always @(*) begin
        rem = 9'd0;
        quotient = 16'd0;

        for (i = 15; i >= 0; i = i - 1) begin
            // Shift remainder left by 1 and bring in the next dividend bit
            rem = {rem[7:0], a_reg[i]};
            if (rem >= {1'b0, b_reg}) begin
                rem = rem - {1'b0, b_reg};
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end
        end

        result = quotient;
        odd = {8'd0, rem[7:0]};  // Remainder zero extended to 16 bits
    end

endmodule