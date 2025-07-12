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

assign q = {thousands, hundreds, tens, ones};

always @ (posedge clk) begin
    if (reset) begin
        ones <= 4'd0;
        tens <= 4'd0;
        hundreds <= 4'd0;
        thousands <= 4'd0;
    end else begin
        if (ones == 4'd9) begin
            ones <= 4'd0;
            if (tens == 4'd9) begin
                tens <= 4'd0;
                if (hundreds == 4'd9) begin
                    hundreds <= 4'd0;
                    if (thousands == 4'd9) begin
                        thousands <= 4'd0;
                    end else begin
                        thousands <= thousands + 4'd1;
                    end
                end else begin
                    hundreds <= hundreds + 4'd1;
                end
            end else begin
                tens <= tens + 4'd1;
            end
        end else begin
            ones <= ones + 4'd1;
        end
    end
end

always @ (posedge clk) begin
    if (reset) begin
        ena[0] <= 1'b0;
        ena[1] <= 1'b0;
        ena[2] <= 1'b0;
    end else begin
        ena[0] <= (ones == 4'd9) ? 1'b1 : 1'b0;
        ena[1] <= (tens == 4'd9 && ones == 4'd9) ? 1'b1 : 1'b0;
        ena[2] <= (hundreds == 4'd9 && tens == 4'd9 && ones == 4'd9) ? 1'b1 : 1'b0;
    end
end

endmodule