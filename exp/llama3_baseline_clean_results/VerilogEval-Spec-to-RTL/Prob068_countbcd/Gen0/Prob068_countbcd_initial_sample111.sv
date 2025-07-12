module TopModule(
    input  clk,
    input  reset,
    output [2:0] ena,
    output [15:0] q
);

reg [3:0] ones, tens, hundreds, thousands;
reg [2:0] ena_reg;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        ones <= 0;
        tens <= 0;
        hundreds <= 0;
        thousands <= 0;
        ena_reg <= 0;
    end else begin
        // Increment ones digit
        ones <= ones + 1;

        // Check for overflow and increment tens digit
        if (ones == 10) begin
            ones <= 0;
            tens <= tens + 1;
            ena_reg[0] <= 1'b1;
        end else begin
            ena_reg[0] <= 1'b0;
        end

        // Check for overflow and increment hundreds digit
        if (tens == 10) begin
            tens <= 0;
            hundreds <= hundreds + 1;
            ena_reg[1] <= 1'b1;
        end else begin
            ena_reg[1] <= 1'b0;
        end

        // Check for overflow and increment thousands digit
        if (hundreds == 10) begin
            hundreds <= 0;
            thousands <= thousands + 1;
            ena_reg[2] <= 1'b1;
        end else begin
            ena_reg[2] <= 1'b0;
        end
    end
end

assign q[3:0] = ones;
assign q[7:4] = tens;
assign q[11:8] = hundreds;
assign q[15:12] = thousands;
assign ena = ena_reg;

endmodule