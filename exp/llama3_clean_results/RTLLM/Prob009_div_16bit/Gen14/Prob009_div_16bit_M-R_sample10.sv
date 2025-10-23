module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [15:0] quotient;
reg [15:0] remainder;

wire [15:0] shifted_remainder;
assign shifted_remainder = {remainder[7:0], A[15]};

wire compare_result;
assign compare_result = (shifted_remainder >= {8'd0, B});

reg [15:0] new_quotient;
assign new_quotient = (compare_result)? (quotient | (1 << 15)) : quotient;

reg [15:0] new_remainder;
assign new_remainder = (compare_result)? (shifted_remainder - {8'd0, B}) : shifted_remainder;

always @(*) begin
    quotient = 0;
    remainder = 0;
    
    for (int i = 14; i >= 0; i--) begin
        remainder = {new_remainder[7:0], A[i]};
        if (new_remainder >= {8'd0, B}) begin
            quotient = new_quotient | (1 << i);
            remainder = new_remainder - {8'd0, B};
        end
    end
    
    result = quotient;
    odd = {8'd0, remainder[7:0]};
end

endmodule