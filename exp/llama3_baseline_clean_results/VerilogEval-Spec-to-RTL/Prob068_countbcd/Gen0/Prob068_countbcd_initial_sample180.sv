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

always @(posedge clk) begin
    if (reset) begin
        ones <= 4'd0;
        tens <= 4'd0;
        hundreds <= 4'd0;
        thousands <= 4'd0;
    end else begin
        ones <= ones + 1'd1;

        if (ones == 4'd10) begin
            ones <= 4'd0;
            tens <= tens + 1'd1;

            if (tens == 4'd10) begin
                tens <= 4'd0;
                hundreds <= hundreds + 1'd1;

                if (hundreds == 4'd10) begin
                    hundreds <= 4'd0;
                    thousands <= thousands + 1'd1;

                    if (thousands == 4'd10) begin
                        thousands <= 4'd0;
                    end
                end
            end
        end
    end
end

assign ena[0] = (ones == 4'd9) ? 1'b1 : 1'b0;  // Enable tens digit when ones rolls over
assign ena[1] = (tens == 4'd9 && ones == 4'd9) ? 1'b1 : 1'b0;  // Enable hundreds digit when tens rolls over
assign ena[2] = (hundreds == 4'd9 && tens == 4'd9 && ones == 4'd9) ? 1'b1 : 1'b0;  // Enable thousands digit when hundreds rolls over

assign q[3:0] = ones;
assign q[7:4] = tens;
assign q[11:8] = hundreds;
assign q[15:12] = thousands;

endmodule