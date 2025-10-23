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
    
    for (int i = 15; i >= 8; i--) begin
        if (remainder[15:8] >= B) begin
            quotient = quotient | (1 << i - 8);
            remainder = {remainder[15:8] - B, remainder[7:0]};
        end else begin
            remainder = {remainder[15:8], remainder[7:0]};
        end
        
        if (i < 8) begin
            remainder = {remainder[15:8], remainder[7:0], 1'b0};
        end
    end
    
    result = quotient;
    odd = {8'd0, remainder[7:0]};
end

endmodule