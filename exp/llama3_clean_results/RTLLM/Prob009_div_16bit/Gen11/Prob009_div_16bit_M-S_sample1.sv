module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [7:0] odd
);

reg [15:0] temp;
reg [7:0] remainder;
reg [15:0] quotient;

always @(*) begin
    quotient = 0;
    temp = A;
    remainder = 0;
    for (int i = 15; i >= 0; i--) begin
        if ({temp[15], remainder} >= {1'b0, B}) begin
            quotient[i] = 1'b1;
            remainder = {temp[15], remainder} - {1'b0, B};
        end else begin
            remainder = {temp[15], remainder};
        end
        temp = temp << 1;
    end
    result = quotient;
    odd = remainder;
end

endmodule