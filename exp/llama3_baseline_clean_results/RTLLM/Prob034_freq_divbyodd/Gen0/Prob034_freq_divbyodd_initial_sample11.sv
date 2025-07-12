module freq_divbyodd #(
    parameter NUM_DIV = 5  // Default divisor value
)(
    input  wire        clk,    // Input clock signal
    input  wire        rst_n,  // Active low reset signal
    output wire        clk_div // Divided clock output
);

reg [31:0] cnt1;  // Counter for rising edges
reg [31:0] cnt2;  // Counter for falling edges
reg         clk_div1;  // Clock divider for positive edges
reg         clk_div2;  // Clock divider for negative edges

// Calculate half of the divisor value
localparam integer HALF_DIV = NUM_DIV / 2;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Initialize counters and clock dividers on reset
        cnt1 <= 0;
        cnt2 <= 0;
        clk_div1 <= 1'b0;
        clk_div2 <= 1'b0;
    end else begin
        // Increment counters on rising and falling edges
        if (cnt1 < HALF_DIV) begin
            cnt1 <= cnt1 + 1;
        end else if (cnt1 == HALF_DIV) begin
            cnt1 <= 0;
            // Toggle clock divider for positive edges
            clk_div1 <= ~clk_div1;
        end

        if (cnt2 < HALF_DIV) begin
            cnt2 <= cnt2 + 1;
        end else if (cnt2 == HALF_DIV) begin
            cnt2 <= 0;
            // Toggle clock divider for negative edges
            clk_div2 <= ~clk_div2;
        end
    end
end

// Derive final divided clock output by OR-ing clock dividers
assign clk_div = clk_div1 | clk_div2;

endmodule