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
    
    for (int i = 15; i >= 0; i--) begin
        reg [15:0] temp_remainder;
        reg [15:0] temp_quotient;
        
        if (remainder >= {8'd0, B}) begin
            temp_quotient = 1 << i;
            temp_remainder = remainder - {8'd0, B};
        end else begin
            temp_quotient = 0;
            temp_remainder = remainder;
        end
        
        quotient = quotient | temp_quotient;
        remainder = {temp_remainder[7:0], 1'b0};
    end
    
    result = quotient;
    odd = {8'd0, remainder[7:0]};
end

endmodule