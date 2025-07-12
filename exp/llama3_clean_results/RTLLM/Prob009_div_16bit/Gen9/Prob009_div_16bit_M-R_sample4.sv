module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [7:0] odd
);

reg [7:0] quotient;
reg [7:0] remainder;
reg [7:0] temp_remainder;

assign result = {8'd0, quotient};
assign odd = remainder;

always @(*) begin
    quotient = 0;
    remainder = 0;
    temp_remainder = A[15:8];
    
    for (int i = 7; i >= 0; i--) begin
        if (temp_remainder >= B) begin
            quotient = quotient | (1 << i);
            temp_remainder = temp_remainder - B;
        end
        if (i > 0) begin
            temp_remainder = {temp_remainder[7:0], A[7 - i]};
        end
    end
    
    remainder = temp_remainder;
end

endmodule