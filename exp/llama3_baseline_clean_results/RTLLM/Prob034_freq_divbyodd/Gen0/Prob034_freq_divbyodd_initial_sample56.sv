module freq_divbyodd #(
    parameter NUM_DIV = 5 // Default divisor value
)(
    input  wire clk,      // Input clock signal
    input  wire rst_n,    // Active low reset signal
    output wire clk_div   // Divided clock output
);

reg [31:0] cnt1;  // Counter for tracking rising edges
reg [31:0] cnt2;  // Counter for tracking falling edges
reg        clk_div1;  // Divided clock output for positive edges
reg        clk_div2;  // Divided clock output for negative edges

// Calculate half of the divisor value
localparam HALF_DIV = (NUM_DIV - 1) / 2;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt1 <= 0;
        cnt2 <= 0;
        clk_div1 <= 1'b0;
        clk_div2 <= 1'b0;
    end else begin
        // Increment counter for rising edge
        if (cnt1 < HALF_DIV) begin
            cnt1 <= cnt1 + 1;
        end else begin
            cnt1 <= 0;
            // Toggle divided clock output for positive edges
            clk_div1 <= ~clk_div1;
        end

        // Increment counter for falling edge
        if (cnt2 < HALF_DIV) begin
            cnt2 <= cnt2 + 1;
        end else begin
            cnt2 <= 0;
            // Toggle divided clock output for negative edges
            clk_div2 <= ~clk_div2;
        end
    end
end

// Derive final divided clock output by logically OR-ing the divided clock outputs for positive and negative edges
assign clk_div = clk_div1 | clk_div2;

endmodule