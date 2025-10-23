module TopModule(
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;
    reg [2:0] ena_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ones <= 4'd0;
            tens <= 4'd0;
            hundreds <= 4'd0;
            thousands <= 4'd0;
            ena_reg <= 3'b000;
        end else begin
            ones <= (ones == 4'd9)? 4'd0 : ones + 1;
            tens <= (ena_reg[0] && tens == 4'd9)? 4'd0 : (ena_reg[0])? tens + 1 : tens;
            hundreds <= (ena_reg[1] && hundreds == 4'd9)? 4'd0 : (ena_reg[1])? hundreds + 1 : hundreds;
            thousands <= (ena_reg[2] && thousands == 4'd9)? 4'd0 : (ena_reg[2])? thousands + 1 : thousands;

            ena_reg[0] <= (ones == 4'd9);
            ena_reg[1] <= (tens == 4'd9 && ena_reg[0]);
            ena_reg[2] <= (hundreds == 4'd9 && ena_reg[1]);
        end
    end

    assign q = {thousands, hundreds, tens, ones};
    assign ena = ena_reg;

endmodule