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
reg [2:0] ena_reg;

always @(posedge clk) begin
    if (reset) begin
        ones <= 4'b0000;
        tens <= 4'b0000;
        hundreds <= 4'b0000;
        thousands <= 4'b0000;
        ena_reg <= 3'b000;
    end else begin
        ena_reg <= 3'b000;
        if (ones == 4'b1001) begin
            ones <= 4'b0000;
            ena_reg[0] <= 1'b1;
        end else begin
            ones <= ones + 1;
        end

        if (ena_reg[0] && tens == 4'b1001) begin
            tens <= 4'b0000;
            ena_reg[1] <= 1'b1;
        end else if (ena_reg[0]) begin
            tens <= tens + 1;
        end

        if (ena_reg[1] && hundreds == 4'b1001) begin
            hundreds <= 4'b0000;
            ena_reg[2] <= 1'b1;
        end else if (ena_reg[1]) begin
            hundreds <= hundreds + 1;
        end

        if (ena_reg[2] && thousands == 4'b1001) begin
            thousands <= 4'b0000;
        end else if (ena_reg[2]) begin
            thousands <= thousands + 1;
        end
    end
end

assign q = {thousands, hundreds, tens, ones};
assign ena = ena_reg;

endmodule