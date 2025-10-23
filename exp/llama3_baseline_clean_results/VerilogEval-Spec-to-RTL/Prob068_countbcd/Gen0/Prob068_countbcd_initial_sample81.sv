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

assign q[3:0] = ones;
assign q[7:4] = tens;
assign q[11:8] = hundreds;
assign q[15:12] = thousands;

assign ena[0] = (ones == 4'd9) ? 1'b1 : 1'b0;  // enable tens when ones rolls over
assign ena[1] = (tens == 4'd9 && ones == 4'd0) ? 1'b1 : 1'b0;  // enable hundreds when tens rolls over
assign ena[2] = (hundreds == 4'd9 && tens == 4'd0 && ones == 4'd0) ? 1'b1 : 1'b0;  // enable thousands when hundreds rolls over

always @(posedge clk) begin
    if (reset) begin
        ones <= 4'd0;
        tens <= 4'd0;
        hundreds <= 4'd0;
        thousands <= 4'd0;
    end else begin
        if (ena[0] == 1'b1) begin
            ones <= 4'd0;
            if (ena[1] == 1'b1) begin
                tens <= 4'd0;
                if (ena[2] == 1'b1) begin
                    hundreds <= 4'd0;
                    thousands <= thousands + 1;
                    if (thousands == 4'd10) thousands <= 4'd0;
                end else begin
                    hundreds <= hundreds + 1;
                    if (hundreds == 4'd10) hundreds <= 4'd0;
                end
            end else begin
                tens <= tens + 1;
                if (tens == 4'd10) tens <= 4'd0;
            end
        end else begin
            ones <= ones + 1;
            if (ones == 4'd10) ones <= 4'd0;
        end
    end
end

endmodule