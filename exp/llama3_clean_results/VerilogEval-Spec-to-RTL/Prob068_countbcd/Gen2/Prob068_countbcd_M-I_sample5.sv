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
    end else begin
        reg inc_ones, inc_tens, inc_hundreds, inc_thousands;

        // Increment the ones digit
        if (q_ones == 9) begin
            q_ones <= 0;
            inc_ones = 1;
        end else begin
            q_ones <= q_ones + 1;
            inc_ones = 0;
        end

        // Increment the tens digit
        if (inc_ones && q_tens == 9) begin
            q_tens <= 0;
            inc_tens = 1;
        end else if (inc_ones) begin
            q_tens <= q_tens + 1;
            inc_tens = 0;
        end else begin
            inc_tens = 0;
        end

        // Increment the hundreds digit
        if (inc_tens && q_hundreds == 9) begin
            q_hundreds <= 0;
            inc_hundreds = 1;
        end else if (inc_tens) begin
            q_hundreds <= q_hundreds + 1;
            inc_hundreds = 0;
        end else begin
            inc_hundreds = 0;
        end

        // Increment the thousands digit
        if (inc_hundreds && q_thousands == 9) begin
            q_thousands <= 0;
        end else if (inc_hundreds) begin
            q_thousands <= q_thousands + 1;
        end

        // Generate enable signals
        ena[0] <= inc_ones;
        ena[1] <= inc_tens;
        ena[2] <= inc_hundreds;
    end
end

endmodule