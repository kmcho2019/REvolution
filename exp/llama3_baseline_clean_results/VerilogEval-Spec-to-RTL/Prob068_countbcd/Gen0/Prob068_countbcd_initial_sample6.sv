module TopModule(
    input  clk,
    input  reset,
    output [2:0] ena,
    output [15:0] q
);

reg [3:0] digit_ones, digit_tens, digit_hundreds, digit_thousands;
reg [2:0] ena_reg;

always @(posedge clk or posedge reset) begin
    if(reset) begin
        digit_ones <= 4'd0;
        digit_tens <= 4'd0;
        digit_hundreds <= 4'd0;
        digit_thousands <= 4'd0;
        ena_reg <= 3'd0;
    end else begin
        ena_reg <= 3'd0; // default all enables to 0
        if(digit_ones == 4'd9) begin
            digit_ones <= 4'd0;
            ena_reg[0] <= 1'd1;
        end else begin
            digit_ones <= digit_ones + 1'd1;
        end

        if(ena_reg[0] && digit_tens == 4'd9) begin
            digit_tens <= 4'd0;
            ena_reg[1] <= 1'd1;
        end else if (ena_reg[0]) begin
            digit_tens <= digit_tens + 1'd1;
        end

        if(ena_reg[1] && digit_hundreds == 4'd9) begin
            digit_hundreds <= 4'd0;
            ena_reg[2] <= 1'd1;
        end else if (ena_reg[1]) begin
            digit_hundreds <= digit_hundreds + 1'd1;
        end

        if(ena_reg[2] && digit_thousands == 4'd9) begin
            digit_thousands <= 4'd0;
        end else if (ena_reg[2]) begin
            digit_thousands <= digit_thousands + 1'd1;
        end
    end
end

assign q = {digit_thousands, digit_hundreds, digit_tens, digit_ones};
assign ena = ena_reg;

endmodule