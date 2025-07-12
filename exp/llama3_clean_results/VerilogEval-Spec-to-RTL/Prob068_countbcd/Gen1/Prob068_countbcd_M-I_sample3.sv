module TopModule(
    input  clk,
    input  reset,
    output [2:0] ena,
    output [15:0] q
);

reg [3:0] q_ones;
reg [3:0] q_tens;
reg [3:0] q_hundreds;
reg [3:0] q_thousands;
reg [2:0] ena_reg; // Declare ena as reg here

assign q = {q_thousands, q_hundreds, q_tens, q_ones};
assign ena = ena_reg; // Continuous assignment to output

always @(posedge clk) begin
    if (reset) begin
        q_ones <= 0;
        q_tens <= 0;
        q_hundreds <= 0;
        q_thousands <= 0;
        ena_reg <= 0;
    end else begin
        // Always increment the ones digit
        if (q_ones == 9) begin
            q_ones <= 0;
            ena_reg[0] <= 1;
        end else begin
            q_ones <= q_ones + 1;
            ena_reg[0] <= 0;
        end

        // Only increment the tens digit when the ones digit wraps around
        if (q_ones == 0 && q_tens < 9) begin
            q_tens <= q_tens + 1;
            ena_reg[1] <= 1;
        end else if (q_ones == 0 && q_tens == 9) begin
            q_tens <= 0;
            ena_reg[1] <= 1;
        end else begin
            ena_reg[1] <= 0;
        end

        // Only increment the hundreds digit when the tens digit wraps around
        if (q_ones == 0 && q_tens == 0 && q_hundreds < 9) begin
            q_hundreds <= q_hundreds + 1;
            ena_reg[2] <= 1;
        end else if (q_ones == 0 && q_tens == 0 && q_hundreds == 9) begin
            q_hundreds <= 0;
            ena_reg[2] <= 1;
        end else begin
            ena_reg[2] <= 0;
        end

        // Only increment the thousands digit when the hundreds digit wraps around
        if (q_ones == 0 && q_tens == 0 && q_hundreds == 0 && q_thousands < 9) begin
            q_thousands <= q_thousands + 1;
        end else if (q_ones == 0 && q_tens == 0 && q_hundreds == 0 && q_thousands == 9) begin
            q_thousands <= 0;
        end
    end
end

endmodule