module TopModule(
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

// Internal signals
reg [3:0] ones;
reg [3:0] tens;
reg [3:0] hundreds;
reg [3:0] thousands;

assign ena[0] = (tens == 9) ? 1'b1 : 1'b0;
assign ena[1] = (hundreds == 9 && tens == 9) ? 1'b1 : 1'b0;
assign ena[2] = (thousands == 9 && hundreds == 9 && tens == 9) ? 1'b1 : 1'b0;

assign q[3:0] = ones;
assign q[7:4] = tens;
assign q[11:8] = hundreds;
assign q[15:12] = thousands;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        ones <= 4'd0;
        tens <= 4'd0;
        hundreds <= 4'd0;
        thousands <= 4'd0;
    end else begin
        if (ones == 9) begin
            ones <= 4'd0;
            if (tens == 9) begin
                tens <= 4'd0;
                if (hundreds == 9) begin
                    hundreds <= 4'd0;
                    if (thousands == 9) begin
                        thousands <= 4'd0;
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

endmodule