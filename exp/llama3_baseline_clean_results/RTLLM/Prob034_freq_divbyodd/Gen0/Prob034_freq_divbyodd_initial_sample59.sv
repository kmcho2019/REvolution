module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input  clk,
    input  rst_n,
    output clk_div
);

reg [31:0] cnt1;
reg [31:0] cnt2;
reg        clk_div1;
reg        clk_div2;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt1 <= 0;
        cnt2 <= 0;
        clk_div1 <= 0;
        clk_div2 <= 0;
    end else begin
        // Count on rising edge
        if (cnt1 == (NUM_DIV - 1) / 2) begin
            cnt1 <= 0;
            clk_div1 <= ~clk_div1;
        end else if (cnt1!= (NUM_DIV - 1)) begin
            cnt1 <= cnt1 + 1;
        end

        // Count on falling edge
        if (cnt2 == (NUM_DIV - 1) / 2) begin
            cnt2 <= 0;
            clk_div2 <= ~clk_div2;
        end else if (cnt2!= (NUM_DIV - 1)) begin
            cnt2 <= cnt2 + 1;
        end
    end
end

assign clk_div = (clk_div1 | clk_div2);

endmodule