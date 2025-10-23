module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input  wire        clk,  // Input clock signal
    input  wire        rst_n, // Active low reset signal
    output wire        clk_div // Divided clock output
);

reg [($clog2(NUM_DIV)) - 1:0] cnt1; // Counter for rising edges
reg [($clog2(NUM_DIV)) - 1:0] cnt2; // Counter for falling edges
reg                       clk_div1; // Clock divider for positive edges
reg                       clk_div2; // Clock divider for negative edges

// Initialize counters and clock dividers on reset
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt1 <= 0;
        cnt2 <= 0;
        clk_div1 <= 1'b0;
        clk_div2 <= 1'b0;
    end else begin
        // Count rising edges
        if (cnt1 == (NUM_DIV / 2) - 1) begin
            cnt1 <= 0;
            clk_div1 <= ~clk_div1;
        end else begin
            cnt1 <= cnt1 + 1;
        end

        // Count falling edges
        if (cnt2 == (NUM_DIV / 2) - 1) begin
            cnt2 <= 0;
            clk_div2 <= ~clk_div2;
        end else begin
            cnt2 <= cnt2 + 1;
        end
    end
end

// Derive final divided clock output
assign clk_div = clk_div1 | clk_div2;

endmodule