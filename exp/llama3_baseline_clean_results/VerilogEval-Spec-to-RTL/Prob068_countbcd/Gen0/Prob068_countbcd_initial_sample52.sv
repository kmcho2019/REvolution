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
        ones <= 0;
        tens <= 0;
        hundreds <= 0;
        thousands <= 0;
    end else begin
        ena[0] <= (ones == 4'd9) ? 1'b1 : 1'b0;
        ena[1] <= (tens == 4'd9 && ones == 4'd0) ? 1'b1 : 1'b0;
        ena[2] <= (hundreds == 4'd9 && tens == 4'd0 && ones == 4'd0) ? 1'b1 : 1'b0;
        
        if (ones == 4'd9) begin
            ones <= 0;
            if (tens == 4'd9) begin
                tens <= 0;
                if (hundreds == 4'd9) begin
                    hundreds <= 0;
                    if (thousands == 4'd9) begin
                        thousands <= 0;
                    end else begin
                        thousands <= thousands + 1;
                    end
                end else if (hundreds < 4'd9) begin
                    hundreds <= hundreds + 1;
                end
            end else if (tens < 4'd9) begin
                tens <= tens + 1;
            end
        end else begin
            ones <= ones + 1;
        end
    end
end

assign q[3:0] = ones;
assign q[7:4] = tens;
assign q[11:8] = hundreds;
assign q[15:12] = thousands;

endmodule