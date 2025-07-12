module freq_divbyodd #(
    parameter NUM_DIV = 5 // Default odd divisor value
)(
    input  wire clk,     // Input clock signal
    input  wire rst_n,   // Active low reset signal
    output wire clk_div  // Divided clock output
);

reg [31:0] cnt1; // Counter for rising edge
reg [31:0] cnt2; // Counter for falling edge
reg        clk_div1; // Clock divider for positive edge
reg        clk_div2; // Clock divider for negative edge

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Initialize counters and clock dividers on reset
        cnt1 <= 0;
        cnt2 <= 0;
        clk_div1 <= 0;
        clk_div2 <= 0;
    end else begin
        // Count up to NUM_DIV - 1
        if (cnt1 == (NUM_DIV - 1) / 2) begin
            cnt1 <= 0;
            // Toggle clk_div1 on positive edge
            clk_div1 <= ~clk_div1;
        end else begin
            cnt1 <= cnt1 + 1;
        end

        if (cnt2 == (NUM_DIV - 1) / 2) begin
            cnt2 <= 0;
            // Toggle clk_div2 on negative edge
            clk_div2 <= ~clk_div2;
        end else begin
            cnt2 <= cnt2 + 1;
        end
    end
end

// Logically OR clk_div1 and clk_div2 to account for both clock edges
assign clk_div = clk_div1 | clk_div2;

endmodule