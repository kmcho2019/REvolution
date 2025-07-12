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
        ones <= ones + 1;
        if (ones == 10) begin
            ones <= 0;
            tens <= tens + 1;
            if (tens == 10) begin
                tens <= 0;
                hundreds <= hundreds + 1;
                if (hundreds == 10) begin
                    hundreds <= 0;
                    thousands <= thousands + 1;
                end
            end
        end
    end
end

assign ena[0] = (ones == 9)? 1 : 0;
assign ena[1] = (tens == 9 && ones == 0)? 1 : 0;
assign ena[2] = (hundreds == 9 && tens == 0 && ones == 0)? 1 : 0;

assign q[3:0] = ones;
assign q[7:4] = tens;
assign q[11:8] = hundreds;
assign q[15:12] = thousands;

endmodule