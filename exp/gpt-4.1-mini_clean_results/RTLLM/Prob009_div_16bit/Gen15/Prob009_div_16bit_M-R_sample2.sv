module div_16bit (
    input  wire [15:0] A,      // Dividend
    input  wire [7:0]  B,      // Divisor
    output reg  [15:0] result, // Quotient
    output reg  [15:0] odd     // Remainder (zero-extended)
);

    // Internal registers to hold input copies
    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // Always block 1: Latch inputs to internal registers (combinational)
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Always block 2: Division logic (combinational)
    always @(*) begin
        // Variables for division process
        reg [8:0] remainder;      // 9-bit to hold intermediate remainder
        reg [15:0] quotient;      // 16-bit quotient
        integer i;

        remainder = 9'd0;
        quotient = 16'd0;

        // Division algorithm: shift-subtract method
        for (i = 15; i >= 0; i = i - 1) begin
            // Shift remainder left by 1 and bring down next dividend bit
            remainder = {remainder[7:0], a_reg[i]};
            // Compare and subtract if possible
            if (remainder >= {1'b0, b_reg}) begin
                remainder = remainder - {1'b0, b_reg};
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end
        end

        result = quotient;
        odd = {8'd0, remainder[7:0]};  // zero-extend remainder to 16 bits
    end

endmodule