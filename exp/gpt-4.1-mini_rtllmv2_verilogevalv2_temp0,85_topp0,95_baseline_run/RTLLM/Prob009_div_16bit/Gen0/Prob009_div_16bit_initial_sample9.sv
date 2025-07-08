module div_16bit (
    input  wire [15:0] A,
    input  wire [7:0]  B,
    output reg  [15:0] result,
    output reg  [15:0] odd
);

    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // Register inputs A and B into internal regs a_reg and b_reg
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Combinational division process
    always @(*) begin
        reg [15:0] quotient;
        reg [7:0]  remainder;
        integer i;
        reg [8:0] temp; // 9 bits to hold remainder shifted left + next bit

        quotient = 16'b0;
        remainder = 8'b0;
        temp = 9'b0;

        // Iterate over all 16 bits of a_reg from MSB to LSB
        for (i = 15; i >= 0; i = i - 1) begin
            // Shift remainder left by 1, bring in current bit of dividend
            temp = {remainder, a_reg[i]};
            if (temp[8:1] >= b_reg) begin
                temp[8:1] = temp[8:1] - b_reg;
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end
            remainder = temp[8:1];
        end

        result = quotient;
        odd = {8'b0, remainder}; // remainder in lower 8 bits of odd, upper bits zero
    end

endmodule