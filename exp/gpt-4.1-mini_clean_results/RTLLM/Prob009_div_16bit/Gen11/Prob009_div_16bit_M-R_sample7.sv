module div_16bit(
    input  [15:0] A,
    input  [7:0]  B,
    output reg [15:0] result,
    output reg [15:0] odd
);

    // Internal registers to latch inputs (combinationally)
    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // First combinational block: latch inputs into internal registers
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Second combinational block: perform combinational division using iterative remainder and quotient arrays
    always @(*) begin
        integer i;
        reg [8:0] remainder [0:16]; // 17 stages of 9-bit remainder to hold shifted bits
        reg [15:0] quotient_tmp;    // Temporary quotient

        // Initialize remainder[0] to zero
        remainder[0] = 9'b0;
        quotient_tmp = 16'b0;

        // Iterate over dividend bits MSB to LSB
        for (i = 0; i < 16; i = i + 1) begin
            // Shift previous remainder left by 1 and bring down current dividend bit (from MSB to LSB)
            remainder[i+1] = {remainder[i][7:0], a_reg[15 - i]};
            
            // Compare remainder and divisor (divisor extended to 9 bits)
            if (remainder[i+1] >= {1'b0, b_reg}) begin
                remainder[i+1] = remainder[i+1] - {1'b0, b_reg};
                quotient_tmp[15 - i] = 1'b1; // Set quotient bit
            end else begin
                quotient_tmp[15 - i] = 1'b0;
            end
        end

        // Assign outputs
        result = quotient_tmp;
        odd    = {8'b0, remainder[16][7:0]}; // final remainder zero-extended to 16 bits
    end

endmodule