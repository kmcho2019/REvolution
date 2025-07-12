module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [15:0] quotient;
reg [15:0] remainder;
reg [3:0] counter;

always @(*) begin
    quotient = 0;
    remainder = 0;
    counter = 15;

    while (counter >= 0) begin
        remainder = {remainder[7:0], A[counter]};
        if (remainder >= {8'd0, B}) begin
            quotient = quotient | (1 << counter);
            remainder = remainder - {8'd0, B};
        end
        counter = counter - 1;
    end

    result = quotient;
    odd = {8'd0, remainder[7:0]};
end

endmodule