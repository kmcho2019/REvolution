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
        if (ones == 4'b1010) begin // 10 in decimal
            ones <= 4'b0000;
            if (tens == 4'b1010) begin // 10 in decimal
                tens <= 4'b0000;
                if (hundreds == 4'b1010) begin // 10 in decimal
                    hundreds <= 4'b0000;
                    if (thousands == 4'b1010) begin // 10 in decimal
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

always @(*) begin
    ena[0] = (ones == 4'b1010) ? 1'b1 : 1'b0;
    ena[1] = (tens == 4'b1010) && (ones == 4'b1010) ? 1'b1 : 1'b0;
    ena[2] = (hundreds == 4'b1010) && (tens == 4'b1010) && (ones == 4'b1010) ? 1'b1 : 1'b0;
    q[3:0] = ones;
    q[7:4] = tens;
    q[11:8] = hundreds;
    q[15:12] = thousands;
end

endmodule