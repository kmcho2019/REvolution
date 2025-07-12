module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [15:0] a_reg;
reg [7:0] b_reg;

always @(*) begin
    a_reg = A;
    b_reg = B;
end

always @(*) begin
    reg [15:0] quotient;
    reg [15:0] temp;

    if (b_reg == 0) begin
        // Handle division by zero
        result = 16'hFFFF;
        odd = 16'hFFFF;
    end else if (b_reg > a_reg) begin
        // Handle divisor larger than dividend
        result = 0;
        odd = a_reg;
    end else begin
        quotient = 0;
        temp = a_reg;

        while (temp >= b_reg) begin
            temp = temp - b_reg;
            quotient = quotient + 1;
        end

        // Assign the final quotient and remainder
        result = quotient;
        odd = temp;
    end
end

endmodule