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

    // Perform combinational division
    always @(*) begin
        reg [23:0] temp;       // {8-bit remainder, 16-bit dividend bits}
        reg [15:0] quotient;
        integer i;

        temp = {8'd0, a_reg};  // Initialize remainder=0 and dividend bits
        quotient = 16'b0;

        for (i = 15; i >= 0; i = i - 1) begin
            // Extract upper 8 bits (current remainder candidate)
            if (temp[23:16] >= b_reg) begin
                temp[23:16] = temp[23:16] - b_reg; // Subtract divisor from remainder bits
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end
            temp = temp << 1; // Shift left by 1 to bring down next dividend bit
        end

        result = quotient;
        odd = temp[23:8]; // Final remainder is upper 16 bits of temp after last shift
    end

endmodule