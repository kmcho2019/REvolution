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

always @(posedge clk) begin
    if (reset) begin
        ones <= 0;
        tens <= 0;
        hundreds <= 0;
        thousands <= 0;
    end else begin
        if (ones == 4'd9) begin
            ones <= 0;
            if (tens == 4'd9) begin
                tens <= 0;
                if (hundreds == 4'd9) begin
                    hundreds <= 0;
                    if (thousands == 4'd9) begin
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

always @(ones, tens, hundreds, thousands) begin
    q[3:0] <= ones;
    q[7:4] <= tens;
    q[11:8] <= hundreds;
    q[15:12] <= thousands;

    if (ones == 4'd9) begin
        ena[0] <= 1;
    end else begin
        ena[0] <= 0;
    end

    if (tens == 4'd9 && ones == 4'd0) begin
        ena[1] <= 1;
    end else begin
        ena[1] <= 0;
    end

    if (hundreds == 4'd9 && tens == 4'd0 && ones == 4'd0) begin
        ena[2] <= 1;
    end else begin
        ena[2] <= 0;
    end
end

endmodule