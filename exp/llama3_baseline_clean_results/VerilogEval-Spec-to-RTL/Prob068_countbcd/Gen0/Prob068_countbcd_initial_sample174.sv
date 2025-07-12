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

assign q[3:0] = ones;
assign q[7:4] = tens;
assign q[11:8] = hundreds;
assign q[15:12] = thousands;

always @(posedge clk) begin
    if (reset) begin
        ones <= 0;
        tens <= 0;
        hundreds <= 0;
        thousands <= 0;
        ena <= 0;
    end else begin
        if (ones == 9) begin
            ones <= 0;
            ena[0] <= 1; // Enable tens digit
            if (tens == 9) begin
                tens <= 0;
                ena[1] <= 1; // Enable hundreds digit
                if (hundreds == 9) begin
                    hundreds <= 0;
                    ena[2] <= 1; // Enable thousands digit
                    if (thousands == 9) begin
                        thousands <= 0;
                    end else begin
                        thousands <= thousands + 1;
                    end
                end else begin
                    hundreds <= hundreds + 1;
                    ena[2] <= 0;
                end
            end else begin
                tens <= tens + 1;
                ena[1] <= 0;
                ena[2] <= 0;
            end
        end else begin
            ones <= ones + 1;
            ena[0] <= 0;
            ena[1] <= 0;
            ena[2] <= 0;
        end
    end
end

endmodule