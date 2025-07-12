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
        q_ones <= 4'b0;
        q_tens <= 4'b0;
        q_hundreds <= 4'b0;
        q_thousands <= 4'b0;
    end else begin
        if (q_ones == 4'd9) begin
            q_ones <= 4'b0;
            if (q_tens == 4'd9) begin
                q_tens <= 4'b0;
                if (q_hundreds == 4'd9) begin
                    q_hundreds <= 4'b0;
                    if (q_thousands == 4'd9) begin
                        q_thousands <= 4'b0;
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

always @(*) begin
    ena[0] = 1'b1;
    ena[1] = (q_ones == 4'd9) ? 1'b1 : 1'b0;
    ena[2] = (q_tens == 4'd9 && q_ones == 4'd9) ? 1'b1 : 1'b0;
    ena[2] = (q_hundreds == 4'd9 && q_tens == 4'd9 && q_ones == 4'd9) ? 1'b1 : ena[2];
    ena[2] = (q_thousands == 4'd9 && q_hundreds == 4'd9 && q_tens == 4'd9 && q_ones == 4'd9) ? 1'b1 : ena[2];
    ena[0] = 1'b1;
    ena[1] = (q_ones == 4'd9) ? 1'b1 : 1'b0;
    ena[2] = (q_tens == 4'd9 && q_ones == 4'd9) ? 1'b1 : 1'b0;
    q = {q_thousands, q_hundreds, q_tens, q_ones};
end

endmodule