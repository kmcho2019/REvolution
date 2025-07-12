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
        ones <= 4'b0000;
        tens <= 4'b0000;
        hundreds <= 4'b0000;
        thousands <= 4'b0000;
    end else begin
        if (ones == 4'b1001) begin
            ones <= 4'b0000;
            if (tens == 4'b1001) begin
                tens <= 4'b0000;
                if (hundreds == 4'b1001) begin
                    hundreds <= 4'b0000;
                    if (thousands == 4'b1001) begin
                        thousands <= 4'b0000;
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

assign ena[0] = (tens == 4'b1001) ? 1'b1 : 1'b0;
assign ena[1] = (hundreds == 4'b1001) ? 1'b1 : 1'b0;
assign ena[2] = (thousands == 4'b1001) ? 1'b1 : 1'b0;

assign q[3:0] = ones;
assign q[7:4] = tens;
assign q[11:8] = hundreds;
assign q[15:12] = thousands;

endmodule