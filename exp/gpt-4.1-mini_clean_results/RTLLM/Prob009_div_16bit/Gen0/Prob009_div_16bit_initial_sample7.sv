module div_16bit(
    input  wire [15:0] A,
    input  wire [7:0]  B,
    output reg  [15:0] result,
    output reg  [15:0] odd
);

    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // Latch inputs into registers (combinational)
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Division logic (combinational)
    integer i;
    reg [15:0] quotient;
    reg [15:0] remainder;
    reg [7:0]  cmp_bits;

    always @(*) begin
        quotient = 0;
        remainder = 0;

        // Start division from MSB to LSB
        // We take 8 bits of remainder + next bit of dividend each iteration
        for (i = 15; i >= 0; i = i - 1) begin
            // shift remainder left by 1 and bring in next dividend bit
            remainder = {remainder[14:0], a_reg[i]};
            cmp_bits = remainder[15:8]; // higher 8 bits of remainder

            if (cmp_bits >= b_reg) begin
                cmp_bits = cmp_bits - b_reg;
                remainder[15:8] = cmp_bits;
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end
        end
        result = quotient;
        odd = remainder;
    end

endmodule