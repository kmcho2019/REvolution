module TopModule(
    input  clk,
    input  reset,
    output [2:0] ena,
    output [15:0] q
);

reg [3:0] ones;
reg [3:0] tens;
reg [3:0] hundreds;
reg [3:0] thousands;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        ones <= 4'b0;
        tens <= 4'b0;
        hundreds <= 4'b0;
        thousands <= 4'b0;
    end else begin
        ones <= ones + 4'b1;
        
        if (ones == 4'b1001) begin
            ones <= 4'b0;
            tens <= tens + 4'b1;
        end
        
        if (tens == 4'b1001) begin
            tens <= 4'b0;
            hundreds <= hundreds + 4'b1;
        end
        
        if (hundreds == 4'b1001) begin
            hundreds <= 4'b0;
            thousands <= thousands + 4'b1;
        end
    end
end

assign ena[0] = (tens == 4'b1001) ? 1'b1 : 1'b0;
assign ena[1] = (hundreds == 4'b1001) ? 1'b1 : 1'b0;
assign ena[2] = (thousands == 4'b1001) ? 1'b1 : 1'b0;

assign q[3:0] = ones;
assign q[7:4] = tens;
assign q[11:8] = hundreds;
assign q[15:12] = thousands;

endmodule