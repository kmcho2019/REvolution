module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [15:0] quotient;
reg [15:0] remainder;

always @(*) begin
    quotient = 0;
    remainder = A;
end

always @(*) begin
    if (B == 0) begin
        result = 16'd0;
        odd = A;
    end else begin
        for (int i = 8; i >= 0; i--) begin
            if ({remainder[15:8], 8'd0} >= {B, 8'd0}) begin
                quotient = quotient | (1 << i);
                remainder = {remainder[15:8] - B, remainder[7:0]};
            end else begin
                remainder = {remainder[15:8], remainder[7:0]};
            end
        end
        result = quotient;
        odd = {8'd0, remainder[7:0]};
    end
end

endmodule