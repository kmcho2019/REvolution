module TopModule(
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

reg [3:0] ones, tens, hundreds, thousands;
reg [2:0] ena_reg;

always @(posedge clk) begin
    if (reset) begin
        ones <= 0;
        tens <= 0;
        hundreds <= 0;
        thousands <= 0;
        ena_reg <= 0;
    end else begin
        ena_reg <= 0;
        if (ones == 9) begin
            ones <= 0;
            ena_reg[0] <= 1;
        end else begin
            ones <= ones + 1;
        end

        if (ena_reg[0] == 1) begin
            if (tens == 9) begin
                tens <= 0;
                ena_reg[1] <= 1;
            end else begin
                tens <= tens + 1;
            end
        end

        if (ena_reg[1] == 1) begin
            if (hundreds == 9) begin
                hundreds <= 0;
                ena_reg[2] <= 1;
            end else begin
                hundreds <= hundreds + 1;
            end
        end

        if (ena_reg[2] == 1) begin
            if (thousands == 9) begin
                thousands <= 0;
            end else begin
                thousands <= thousands + 1;
            end
        end
    end
end

assign q[3:0] = ones;
assign q[7:4] = tens;
assign q[11:8] = hundreds;
assign q[15:12] = thousands;
assign ena = ena_reg;

endmodule