module div_16bit (
    input  wire [15:0] A,
    input  wire [7:0]  B,
    output reg  [15:0] result,
    output reg  [15:0] odd
);

    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // Latch inputs in registers (combinational)
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Combinational division logic implementing the described algorithm
    always @(*) begin
        reg [15:0] quotient;
        reg [8:0] remainder; // 9 bits to hold remainder + next dividend bit
        integer i;

        quotient = 16'b0;
        remainder = 9'b0;

        for (i = 15; i >= 0; i = i -1) begin
            // Shift remainder left by 1, bring down next bit of a_reg
            remainder = {remainder[7:0], a_reg[i]};

            // Compare and subtract if possible
            if (remainder[8:1] >= b_reg) begin
                // remainder[8:1] - b_reg, keep LSB as is (newly shifted in bit)
                remainder[8:1] = remainder[8:1] - b_reg;
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end
        end

        result = quotient;
        odd = {7'b0, remainder[8:0]}; // zero-extend remainder (9 bits) to 16 bits
    end

endmodule