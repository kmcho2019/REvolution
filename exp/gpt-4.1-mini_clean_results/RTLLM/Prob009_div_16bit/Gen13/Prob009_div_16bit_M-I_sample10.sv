module div_16bit (
    input  wire [15:0] A,       // Dividend
    input  wire [7:0]  B,       // Divisor
    output reg  [15:0] result,  // Quotient
    output reg  [15:0] odd      // Remainder (lower 8 bits valid)
);

    reg [15:0] a_reg;  // Registered dividend
    reg [7:0]  b_reg;  // Registered divisor

    // Stage 1: Register inputs combinationally (as requested)
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    integer i;
    reg [8:0] remainder;    // 9-bit remainder to hold subtraction results (8-bit divisor + 1 bit)
    reg [15:0] quotient;    // Quotient bits built iteratively

    // Stage 2: Combinational division iterative logic in always block
    always @(*) begin
        remainder = 9'd0;
        quotient = 16'd0;

        // Perform 16 iterations from MSB to LSB
        for (i = 15; i >= 0; i = i - 1) begin
            // Shift remainder left by 1 and bring next dividend bit
            remainder = {remainder[7:0], a_reg[i]};
            // Compare remainder and divisor
            if (remainder >= {1'b0, b_reg}) begin
                remainder = remainder - {1'b0, b_reg};
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end
        end

        // Assign output
        result = quotient;
        odd = {8'd0, remainder[7:0]};  // zero-extend remainder to 16 bits
    end

endmodule