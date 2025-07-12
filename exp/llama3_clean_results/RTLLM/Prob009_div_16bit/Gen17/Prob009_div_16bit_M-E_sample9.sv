module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [15:0] temp;
reg [7:0] divisor;

assign divisor = B;

always @(*) begin
    result = 0;
    temp = A;
    odd = 0;

    for (int i = 15; i >= 0; i--) begin
        if (temp >= {8'd0, divisor}) begin
            temp = temp - {8'd0, divisor};
            result = result | (1 << i);
        end
        temp = temp << 1;
    end

    odd = {8'd0, temp[7:0]};
end

endmodule