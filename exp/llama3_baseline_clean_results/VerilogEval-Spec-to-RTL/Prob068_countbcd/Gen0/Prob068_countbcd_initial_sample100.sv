module TopModule(
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

reg [3:0] q_ones;
reg [3:0] q_tens;
reg [3:0] q_hundreds;
reg [3:0] q_thousands;

always @(posedge clk) begin
    if (reset) begin
        q_ones <= 0;
        q_tens <= 0;
        q_hundreds <= 0;
        q_thousands <= 0;
    end else begin
        if (q_ones == 9 && ena[0]) begin
            q_ones <= 0;
        end else if (q_ones != 9 || !ena[0]) begin
            q_ones <= q_ones + 1;
        end

        ena[0] <= (q_ones == 9) ? 1 : 0;

        if (q_tens == 9 && ena[1]) begin
            q_tens <= 0;
        end else if (q_tens != 9 || !ena[1]) begin
            q_tens <= q_tens;
        end

        ena[1] <= (q_ones == 9 && q_tens != 9) ? 1 : (q_ones == 9 && q_tens == 9) ? 1 : 0;

        if (q_hundreds == 9 && ena[2]) begin
            q_hundreds <= 0;
        end else if (q_hundreds != 9 || !ena[2]) begin
            q_hundreds <= q_hundreds;
        end

        ena[2] <= (q_tens == 9 && q_hundreds != 9) ? 1 : (q_tens == 9 && q_hundreds == 9) ? 1 : 0;

        if (q_thousands == 9) begin
            q_thousands <= 0;
        end else begin
            q_thousands <= q_thousands;
        end
    end
end

assign q = {q_thousands, q_hundreds, q_tens, q_ones};

endmodule