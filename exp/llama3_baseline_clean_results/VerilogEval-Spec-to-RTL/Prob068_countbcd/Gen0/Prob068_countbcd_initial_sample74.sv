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

assign q[3:0] = ones;
assign q[7:4] = tens;
assign q[11:8] = hundreds;
assign q[15:12] = thousands;

assign ena[0] = (ones == 4'd9)? 1'b1 : 1'b0;
assign ena[1] = (tens == 4'd9 && ones == 4'd9)? 1'b1 : 1'b0;
assign ena[2] = (hundreds == 4'd9 && tens == 4'd9 && ones == 4'd9)? 1'b1 : 1'b0;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        ones <= 4'd0;
        tens <= 4'd0;
        hundreds <= 4'd0;
        thousands <= 4'd0;
    end else begin
        if (ones < 4'd9) begin
            ones <= ones + 1;
        end else begin
            ones <= 4'd0;
            if (tens < 4'd9) begin
                tens <= tens + 1;
            end else begin
                tens <= 4'd0;
                if (hundreds < 4'd9) begin
                    hundreds <= hundreds + 1;
                end else begin
                    hundreds <= 4'd0;
                    if (thousands < 4'd9) begin
                        thousands <= thousands + 1;
                    end else begin
                        thousands <= 4'd0;
                    end
                end
            end
        end
    end
end

endmodule