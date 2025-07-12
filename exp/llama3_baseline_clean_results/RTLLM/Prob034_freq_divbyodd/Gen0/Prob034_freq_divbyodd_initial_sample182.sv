module freq_divbyodd #(
    parameter NUM_DIV = 5
)(
    input clk,
    input rst_n,
    output reg clk_div
);

reg [31:0] cnt1;
reg [31:0] cnt2;
reg clk_div1;
reg clk_div2;
reg rising_edge;
reg falling_edge;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt1 <= 0;
        cnt2 <= 0;
        clk_div1 <= 1'b0;
        clk_div2 <= 1'b0;
        rising_edge <= 1'b0;
        falling_edge <= 1'b0;
    end else begin
        if (rising_edge) begin
            cnt1 <= cnt1 + 1;
            if (cnt1 == (NUM_DIV - 1) / 2) begin
                clk_div1 <= ~clk_div1;
                cnt1 <= 0;
            end
        end else begin
            cnt2 <= cnt2 + 1;
            if (cnt2 == (NUM_DIV - 1) / 2) begin
                clk_div2 <= ~clk_div2;
                cnt2 <= 0;
            end
        end
        rising_edge <= ~rising_edge;
        falling_edge <= ~rising_edge;
    end
end

always @(*) begin
    clk_div = (clk_div1 | clk_div2);
end

endmodule