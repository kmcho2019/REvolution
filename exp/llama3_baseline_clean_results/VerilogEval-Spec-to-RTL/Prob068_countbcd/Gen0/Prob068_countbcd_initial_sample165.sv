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
        // increment ones digit
        if (ones == 9) begin
            ones <= 0;
            ena_reg[0] <= 1'b1;
        end else begin
            ones <= ones + 1;
            ena_reg[0] <= 1'b0;
        end

        // increment tens digit
        if (ena_reg[0] == 1'b1 && tens == 9) begin
            tens <= 0;
            ena_reg[1] <= 1'b1;
        end else if (ena_reg[0] == 1'b1) begin
            tens <= tens + 1;
            ena_reg[1] <= 1'b0;
        end else begin
            ena_reg[1] <= 1'b0;
        end

        // increment hundreds digit
        if (ena_reg[1] == 1'b1 && hundreds == 9) begin
            hundreds <= 0;
            ena_reg[2] <= 1'b1;
        end else if (ena_reg[1] == 1'b1) begin
            hundreds <= hundreds + 1;
            ena_reg[2] <= 1'b0;
        end else begin
            ena_reg[2] <= 1'b0;
        end

        // increment thousands digit
        if (ena_reg[2] == 1'b1) begin
            thousands <= thousands + 1;
        end

        // assign output
        q <= {thousands, hundreds, tens, ones};
        ena <= ena_reg;
    end
end

endmodule