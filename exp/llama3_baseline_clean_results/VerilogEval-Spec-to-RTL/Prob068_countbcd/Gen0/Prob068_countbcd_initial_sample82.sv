module TopModule(
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

reg [3:0] ones;
reg [3:0] tens;
reg [3:0] hundreds;
reg [3:0] thousands;

always @(posedge clk) begin
    if (reset) begin
        ones <= 4'd0;
        tens <= 4'd0;
        hundreds <= 4'd0;
        thousands <= 4'd0;
    end else begin
        ones <= ones + 4'd1;
        
        if (ones == 4'd10) begin
            ones <= 4'd0;
            tens <= tens + 4'd1;
        end
        
        if (tens == 4'd10) begin
            tens <= 4'd0;
            hundreds <= hundreds + 4'd1;
        end
        
        if (hundreds == 4'd10) begin
            hundreds <= 4'd0;
            thousands <= thousands + 4'd1;
        end
        
        if (thousands == 4'd10) begin
            thousands <= 4'd0;
        end
    end
end

assign q[3:0] = ones;
assign q[7:4] = tens;
assign q[11:8] = hundreds;
assign q[15:12] = thousands;

assign ena[0] = (ones == 4'd9) ? 1'b1 : 1'b0;
assign ena[1] = (tens == 4'd9 && ones == 4'd9) ? 1'b1 : 1'b0;
assign ena[2] = (hundreds == 4'd9 && tens == 4'd9 && ones == 4'd9) ? 1'b1 : 1'b0;

endmodule