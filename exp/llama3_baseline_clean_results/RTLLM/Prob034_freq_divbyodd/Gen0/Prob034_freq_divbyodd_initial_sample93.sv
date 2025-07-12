module freq_divbyodd #(
    parameter NUM_DIV = 5  // Odd divisor value, defaults to 5
)(
    input  clk,           // Input clock signal
    input  rst_n,          // Active low reset signal
    output clk_div         // Divided clock output
);

reg [2:0] cnt1;           // Counter for rising edges
reg [2:0] cnt2;           // Counter for falling edges
reg       clk_div1;       // Clock divider for positive edges
reg       clk_div2;       // Clock divider for negative edges

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin     // Active low reset
        cnt1   <= 0;
        cnt2   <= 0;
        clk_div1 <= 0;
        clk_div2 <= 0;
    end else begin
        if (cnt1 == (NUM_DIV - 1) / 2) begin
            cnt1   <= 0;
            clk_div1 <= ~clk_div1;
        end else begin
            cnt1   <= cnt1 + 1;
        end
        
        if (cnt2 == (NUM_DIV - 1) / 2) begin
            cnt2   <= 0;
            clk_div2 <= ~clk_div2;
        end else begin
            // No action on cnt2 for rising edge
        end
    end
end

always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin     // Active low reset
        // No action, handled in posedge block
    end else begin
        if (cnt2 == (NUM_DIV - 1) / 2) begin
            cnt2   <= 0;
            clk_div2 <= ~clk_div2;
        end else begin
            cnt2   <= cnt2 + 1;
        end
        
        // No action on cnt1 for falling edge
    end
end

assign clk_div = clk_div1 | clk_div2;  // Final divided clock output

endmodule