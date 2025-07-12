module TopModule(
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

reg [3:0] q_ones, q_tens, q_hundreds, q_thousands;

always @(posedge clk) begin
    if (reset) begin
        q_ones <= 4'b0000;
        q_tens <= 4'b0000;
        q_hundreds <= 4'b0000;
        q_thousands <= 4'b0000;
    end else begin
        if (q_ones == 4'b1001) begin
            q_ones <= 4'b0000;
            if (q_tens == 4'b1001) begin
                q_tens <= 4'b0000;
                if (q_hundreds == 4'b1001) begin
                    q_hundreds <= 4'b0000;
                    if (q_thousands == 4'b1001) begin
                        q_thousands <= 4'b0000;
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

assign ena[0] = (q_ones == 4'b1001);
assign ena[1] = (q_tens == 4'b1001 && q_ones == 4'b1001);
assign ena[2] = (q_hundreds == 4'b1001 && q_tens == 4'b1001 && q_ones == 4'b1001);

assign q = {q_thousands, q_hundreds, q_tens, q_ones};

endmodule