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
        // Increment ones digit
        q_ones <= q_ones + 1;

        // Check for overflow of ones digit and increment tens digit
        ena[0] <= (q_ones == 10) ? 1'b1 : 1'b0;
        if (q_ones == 10) begin
            q_ones <= 0;
            q_tens <= q_tens + 1;
        end

        // Check for overflow of tens digit and increment hundreds digit
        ena[1] <= (q_tens == 10) ? 1'b1 : 1'b0;
        if (q_tens == 10) begin
            q_tens <= 0;
            q_hundreds <= q_hundreds + 1;
        end

        // Check for overflow of hundreds digit and increment thousands digit
        ena[2] <= (q_hundreds == 10) ? 1'b1 : 1'b0;
        if (q_hundreds == 10) begin
            q_hundreds <= 0;
            q_thousands <= q_thousands + 1;
        end
    end
end

endmodule