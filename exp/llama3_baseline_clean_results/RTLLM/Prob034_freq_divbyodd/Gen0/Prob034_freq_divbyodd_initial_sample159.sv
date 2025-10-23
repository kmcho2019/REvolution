module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input clk,
    input rst_n,
    output reg clk_div
);

reg [31:0] cnt1;
reg [31:0] cnt2;
reg clk_div1;
reg clk_div2;
reg old_clk;

always @(*) begin
    if (!rst_n) begin
        cnt1 <= 0;
        cnt2 <= 0;
        clk_div1 <= 1'b0;
        clk_div2 <= 1'b0;
        clk_div <= 1'b0;
    end else begin
        if (old_clk == 1'b0 && clk == 1'b1) begin // rising edge
            if (cnt1 == (NUM_DIV - 1) / 2) begin
                clk_div1 <= ~clk_div1;
                cnt1 <= 0;
            end else begin
                cnt1 <= cnt1 + 1;
            end
        end else if (old_clk == 1'b1 && clk == 1'b0) begin // falling edge
            if (cnt2 == (NUM_DIV - 1) / 2) begin
                clk_div2 <= ~clk_div2;
                cnt2 <= 0;
            end else begin
                cnt2 <= cnt2 + 1;
            end
        end
        clk_div <= clk_div1 | clk_div2;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        old_clk <= 1'b0;
    end else begin
        old_clk <= clk;
    end
end

endmodule