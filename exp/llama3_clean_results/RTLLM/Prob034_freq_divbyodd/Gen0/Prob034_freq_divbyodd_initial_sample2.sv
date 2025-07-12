module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input  clk,
    input  rst_n,
    output reg clk_div
);

reg [31:0] cnt1;  // Counter for positive edges
reg [31:0] cnt2;  // Counter for negative edges
reg clk_div1;    // Divided clock output for positive edges
reg clk_div2;    // Divided clock output for negative edges

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin  // Reset
        cnt1 <= 0;
        cnt2 <= 0;
        clk_div1 <= 0;
        clk_div2 <= 0;
    end else if (clk) begin  // Positive edge
        if (cnt1 == (NUM_DIV / 2) - 1) begin
            cnt1 <= 0;
            clk_div1 <= ~clk_div1;  // Toggle on half count
        end else begin
            cnt1 <= cnt1 + 1;
        end
    end else begin  // Negative edge
        if (cnt2 == (NUM_DIV / 2) - 1) begin
            cnt2 <= 0;
            clk_div2 <= ~clk_div2;  // Toggle on half count
        end else begin
            cnt2 <= cnt2 + 1;
        end
    end
end

always @(posedge clk or negedge clk) begin
    clk_div <= (clk_div1 | clk_div2);
end

endmodule