module TopModule (
    input clk,
    input reset,
    output reg [2:0] ena,
    output reg [15:0] q
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
        ena <= 3'b000;
        if (ones == 9) begin
            ones <= 0;
            ena[0] <= 1;
            if (tens == 9) begin
                tens <= 0;
                ena[1] <= 1;
                if (hundreds == 9) begin
                    hundreds <= 0;
                    ena[2] <= 1;
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

always @(posedge clk) begin
    q[3:0] <= ones;
    q[7:4] <= tens;
    q[11:8] <= hundreds;
    q[15:12] <= thousands;
end

endmodule