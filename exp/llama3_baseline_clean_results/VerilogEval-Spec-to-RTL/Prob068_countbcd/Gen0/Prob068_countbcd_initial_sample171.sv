module TopModule(
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

reg [3:0] q_ones, q_tens, q_hundreds, q_thousands;
reg [2:0] ena;

assign q = {q_thousands, q_hundreds, q_tens, q_ones};

always @(posedge clk or posedge reset) begin
    if (reset) begin
        q_ones <= 0;
        q_tens <= 0;
        q_hundreds <= 0;
        q_thousands <= 0;
        ena <= 0;
    end else begin
        ena <= 0;
        if (q_ones == 9) begin
            q_ones <= 0;
            ena[0] <= 1;
            if (q_tens == 9) begin
                q_tens <= 0;
                ena[1] <= 1;
                if (q_hundreds == 9) begin
                    q_hundreds <= 0;
                    ena[2] <= 1;
                    if (q_thousands == 9) begin
                        q_thousands <= 0;
                    end else begin
                        q_thousands <= q_thousands + 1;
                    end
                end else begin
                    q_hundreds <= q_hundreds + 1;
                end
            end else begin
                q_tens <= q_tens + 1;
            end
        end else begin
            q_ones <= q_ones + 1;
        end
    end
end

endmodule