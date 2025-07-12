module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input  wire        clk,
    input  wire        rst_n,
    output wire        clk_div
);

reg [$clog2(NUM_DIV):0] cnt1;  // Counter for rising edge
reg [$clog2(NUM_DIV):0] cnt2;  // Counter for falling edge
reg        clk_div1;  // Clock divider for rising edge
reg        clk_div2;  // Clock divider for falling edge

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt1 <= 0;
        cnt2 <= 0;
        clk_div1 <= 1'b0;
        clk_div2 <= 1'b0;
    end else begin
        if (cnt1 == (NUM_DIV - 1)) begin
            cnt1 <= 0;
            if (cnt1 == (NUM_DIV / 2)) begin
                clk_div1 <= ~clk_div1;
            end
        end else begin
            cnt1 <= cnt1 + 1;
        end
    end
end

always @(negedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt2 <= 0;
    end else begin
        if (cnt2 == (NUM_DIV - 1)) begin
            cnt2 <= 0;
            if (cnt2 == (NUM_DIV / 2)) begin
                clk_div2 <= ~clk_div2;
            end
        end else begin
            cnt2 <= cnt2 + 1;
        end
    end
end

assign clk_div = clk_div1 | clk_div2;

endmodule