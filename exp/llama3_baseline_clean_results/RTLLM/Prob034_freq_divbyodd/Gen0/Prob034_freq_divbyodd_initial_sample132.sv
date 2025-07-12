module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input clk,
    input rst_n,
    output reg clk_div
);

reg [31:0] cnt1, cnt2;
reg clk_div1, clk_div2;
reg prev_clk;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt1 <= 0;
        cnt2 <= 0;
        clk_div1 <= 1'b0;
        clk_div2 <= 1'b0;
        prev_clk <= 1'b0;
    end else begin
        if (prev_clk == 1'b0 && clk == 1'b1) begin // rising edge
            if (cnt1 == (NUM_DIV / 2) - 1) begin
                cnt1 <= 0;
                clk_div1 <= ~clk_div1;
            end else begin
                cnt1 <= cnt1 + 1;
            end
        end
        if (prev_clk == 1'b1 && clk == 1'b0) begin // falling edge
            if (cnt2 == (NUM_DIV / 2) - 1) begin
                cnt2 <= 0;
                clk_div2 <= ~clk_div2;
            end else begin
                cnt2 <= cnt2 + 1;
            end
        end
        prev_clk <= clk;
    end
end

always @(*) begin
    clk_div = (clk_div1 | clk_div2);
end

endmodule