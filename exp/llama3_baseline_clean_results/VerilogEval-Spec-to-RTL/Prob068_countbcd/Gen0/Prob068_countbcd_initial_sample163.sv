module TopModule(
    input  clk,
    input  reset,
    output [2:0] ena,
    output [15:0] q
);

reg [3:0] q_ones, q_tens, q_hundreds, q_thousands;
reg [2:0] ena_int;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        q_ones <= 0;
        q_tens <= 0;
        q_hundreds <= 0;
        q_thousands <= 0;
    end else begin
        if (q_ones == 4'd9) begin
            q_ones <= 0;
            if (q_tens == 4'd9) begin
                q_tens <= 0;
                if (q_hundreds == 4'd9) begin
                    q_hundreds <= 0;
                    q_thousands <= q_thousands + 1;
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
    q <= {q_thousands, q_hundreds, q_tens, q_ones};
    ena_int[0] <= (q_ones == 4'd9) ? 1'b1 : 1'b0;
    ena_int[1] <= (q_tens == 4'd9 && q_ones == 4'd9) ? 1'b1 : 1'b0;
    ena_int[2] <= (q_hundreds == 4'd9 && q_tens == 4'd9 && q_ones == 4'd9) ? 1'b1 : 1'b0;
    ena <= ena_int;
end

endmodule