module div_16bit (
    input  wire [15:0] A,
    input  wire [7:0]  B,
    output reg  [15:0] result,
    output reg  [15:0] odd
);

    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // Latch inputs in registers on any change
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Perform combinational division using restoring algorithm
    always @(*) begin
        reg [15:0] quotient;
        reg [7:0] remainder;
        integer i;

        quotient = 16'b0;
        remainder = 8'b0;

        // Process each bit of the dividend
        for (i = 15; i >= 0; i = i - 1) begin
            // Shift remainder left by 1 and bring down next bit of dividend
            remainder = {remainder[6:0], a_reg[i]};
            if (remainder >= b_reg) begin
                remainder = remainder - b_reg;
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end
        end

        result = quotient;
        odd = {8'b0, remainder}; // remainder zero-extended to 16 bits
    end

endmodule