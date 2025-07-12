module freq_divbyodd (
    input  clk,        // Input clock signal
    input  rst_n,      // Active low reset signal
    output clk_div     // Divided clock output
);

parameter NUM_DIV = 5;  // Default divisor value

reg [1:0] cnt1;        // Counter for rising edges
reg [1:0] cnt2;        // Counter for falling edges
reg       clk_div1;    // Clock divider for positive edges
reg       clk_div2;    // Clock divider for negative edges
reg       prev_clk;    // Previous clock value

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt1 <= 0;
        cnt2 <= 0;
        clk_div1 <= 1'b0;
        clk_div2 <= 1'b0;
        prev_clk <= 1'b0;
    end else begin
        if (clk != prev_clk) begin  // Edge detection
            if (clk) begin
                if (cnt1 == (NUM_DIV / 2) - 1) begin
                    clk_div1 <= ~clk_div1;  // Toggle clk_div1
                    cnt1 <= 0;
                end else begin
                    cnt1 <= cnt1 + 1;
                end
            end else begin
                if (cnt2 == (NUM_DIV / 2) - 1) begin
                    clk_div2 <= ~clk_div2;  // Toggle clk_div2
                    cnt2 <= 0;
                end else begin
                    cnt2 <= cnt2 + 1;
                end
            end
        end
        prev_clk <= clk;
    end
end

assign clk_div = clk_div1 | clk_div2;  // Final divided clock output

endmodule