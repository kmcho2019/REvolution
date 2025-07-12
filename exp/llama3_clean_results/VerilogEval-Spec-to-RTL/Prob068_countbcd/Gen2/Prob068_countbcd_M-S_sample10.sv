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

assign q = {q_thousands, q_hundreds, q_tens, q_ones};

always @(posedge clk) begin
    if (reset) begin
        q_ones <= 0;
        q_tens <= 0;
        q_hundreds <= 0;
        q_thousands <= 0;
        ena <= 0;
    end else begin
        // Always increment the ones digit
        if (q_ones == 9) begin
            q_ones <= 0;
            ena[0] <= 1;
        end else begin
            q_ones <= q_ones + 1;
            ena[0] <= 0;
        end

        // Only increment the tens digit when the ones digit wraps around
        if (q_ones == 0 && q_tens < 9) begin
            q_tens <= q_tens + 1;
            ena[1] <= 1;
        end else if (q_ones == 0 && q_tens == 9) begin
            q_tens <= 0;
            ena[1] <= 1;
        end else begin
            ena[1] <= 0;
        end

        // Only increment the hundreds digit when the tens digit wraps around
        if (q_ones == 0 && q_tens == 0 && q_hundreds < 9) begin
            q_hundreds <= q_hundreds + 1;
            ena[2] <= 1;
        end else if (q_ones == 0 && q_tens == 0 && q_hundreds == 9) begin
            q_hundreds <= 0;
            ena[2] <= 1;
        end else begin
            ena[2] <= 0;
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