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
        if (ones == 10'd9) begin
            ones <= 0;
            if (tens == 10'd9) begin
                tens <= 0;
                if (hundreds == 10'd9) begin
                    hundreds <= 0;
                    if (thousands == 10'd9) begin
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

always @(posedge clk) begin
    if (reset) begin
        ena <= 0;
    end else begin
        ena[0] <= (ones == 10'd9) ? 1'b1 : 1'b0;
        ena[1] <= (tens == 10'd9 && ones == 10'd9) ? 1'b1 : 1'b0;
        ena[2] <= (hundreds == 10'd9 && tens == 10'd9 && ones == 10'd9) ? 1'b1 : 1'b0;
    end
end

always @(*) begin
    q <= {thousands, hundreds, tens, ones};
end

endmodule