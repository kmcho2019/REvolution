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

assign q = {q_thousands, q_hundreds, q_tens, q_ones};

always @(posedge clk) begin
    if (reset) begin
        q_ones <= 0;
        q_tens <= 0;
        q_hundreds <= 0;
        q_thousands <= 0;
    end else begin
        q_ones <= q_ones + 1;
        if (q_ones == 10) begin
            q_ones <= 0;
            q_tens <= q_tens + 1;
            if (q_tens == 10) begin
                q_tens <= 0;
                q_hundreds <= q_hundreds + 1;
                if (q_hundreds == 10) begin
                    q_hundreds <= 0;
                    q_thousands <= q_thousands + 1;
                    if (q_thousands == 10) begin
                        q_thousands <= 0;
                    end
                end
            end
        end
    end
end

always @(posedge clk) begin
    if (reset) begin
        ena <= 0;
    end else begin
        ena[0] <= (q_ones == 9) ? 1 : 0;
        ena[1] <= (q_tens == 9 && q_ones == 9) ? 1 : 0;
        ena[2] <= (q_hundreds == 9 && q_tens == 9 && q_ones == 9) ? 1 : 0;
    end
end

endmodule