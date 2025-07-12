module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input  clk,
    input  rst_n,
    output reg clk_div
);

reg [31:0] cnt1;
reg [31:0] cnt2;
reg        clk_div1;
reg        clk_div2;
reg        rising_edge;
reg        falling_edge;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt1         <= 0;
        cnt2         <= 0;
        clk_div1     <= 1'b0;
        clk_div2     <= 1'b0;
        rising_edge  <= 1'b0;
        falling_edge <= 1'b0;
    end else if (rising_edge) begin
        if (cnt1 == (NUM_DIV / 2)) begin
            clk_div1 <= ~clk_div1;
            cnt1     <= 0;
        end else begin
            cnt1 <= cnt1 + 1;
        end
        rising_edge  <= 1'b0;
    end else if (falling_edge) begin
        if (cnt2 == (NUM_DIV / 2)) begin
            clk_div2 <= ~clk_div2;
            cnt2     <= 0;
        end else begin
            cnt2 <= cnt2 + 1;
        end
        falling_edge <= 1'b0;
    end
end

always @(posedge clk) begin
    rising_edge  <= 1'b1;
end

always @(negedge clk) begin
    falling_edge <= 1'b1;
end

always @(*) begin
    clk_div = clk_div1 | clk_div2;
end

endmodule