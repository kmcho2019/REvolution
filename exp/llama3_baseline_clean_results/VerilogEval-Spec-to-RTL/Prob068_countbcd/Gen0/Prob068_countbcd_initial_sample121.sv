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

always @(posedge clk or posedge reset) begin
    if (reset) begin
        ones <= 0;
        tens <= 0;
        hundreds <= 0;
        thousands <= 0;
    end else begin
        if (ones == 9) begin
            ones <= 0;
            if (tens == 9) begin
                tens <= 0;
                if (hundreds == 9) begin
                    hundreds <= 0;
                    if (thousands == 9) begin
                        thousands <= 0;
                    end else begin
                        thousands <= thousands + 1;
                    end
                end else begin
                    hundreds <= hundreds + 1;
                end
            end else begin
                tens <= tens + 1;
            end
        end else begin
            ones <= ones + 1;
        end
    end
end

assign ena[0] = (ones == 9)? 1'b1 : 1'b0;
assign ena[1] = (tens == 9 && ones == 0)? 1'b1 : 1'b0;
assign ena[2] = (hundreds == 9 && tens == 0 && ones == 0)? 1'b1 : 1'b0;

assign q[3:0] = ones;
assign q[7:4] = tens;
assign q[11:8] = hundreds;
assign q[15:12] = thousands;

endmodule