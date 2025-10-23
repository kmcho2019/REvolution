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
    reg [15:0] temp_a;
    reg [7:0] temp_b;
    reg [15:0] quotient;
    reg [15:0] remainder;

    temp_a = a_reg;
    temp_b = b_reg;
    quotient = 0;
    remainder = 0;

    for (int i = 15; i >= 0; i--) begin
        remainder = {remainder[14:0], 1'b0};
        remainder[15:8] = temp_a[15:8];
        if (remainder >= temp_b) begin
            quotient[15-i] = 1;
            remainder = remainder - temp_b;
        end else begin
            quotient[15-i] = 0;
        end
        temp_a = temp_a << 1;
    end

    result = quotient;
    odd = remainder;
end

endmodule