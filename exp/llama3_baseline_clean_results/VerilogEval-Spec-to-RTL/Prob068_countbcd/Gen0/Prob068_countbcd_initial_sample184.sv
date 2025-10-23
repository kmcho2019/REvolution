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
        if (ones == 4'b1010) begin
            ones <= 4'b0000;
            if (tens == 4'b1010) begin
                tens <= 4'b0000;
                if (hundreds == 4'b1010) begin
                    hundreds <= 4'b0000;
                    if (thousands == 4'b1010) begin
                        thousands <= 4'b0000;
                    end else begin
                        thousands <= thousands + 1;
                    end
                    ena[2] <= 1'b1;
                end else begin
                    hundreds <= hundreds + 1;
                    ena[2] <= 1'b0;
                end
                ena[1] <= 1'b1;
            end else begin
                tens <= tens + 1;
                ena[1] <= 1'b0;
            end
            ena[0] <= 1'b1;
        end else begin
            ones <= ones + 1;
            ena[0] <= 1'b0;
        end
    end
end

assign q[3:0] = ones;
assign q[7:4] = tens;
assign q[11:8] = hundreds;
assign q[15:12] = thousands;

endmodule