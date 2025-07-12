module freq_divbyodd #(
    parameter NUM_DIV = 5  // Default divisor value
)(
    input  wire clk,      // Input clock signal
    input  wire rst_n,    // Active low reset signal
    output wire clk_div   // Divided clock output
);

reg [31:0] cnt1;  // Counter for positive edges
reg [31:0] cnt2;  // Counter for negative edges
reg         clk_div1;  // Clock divider for positive edges
reg         clk_div2;  // Clock divider for negative edges

// Calculate half of NUM_DIV
localparam HALF_DIV = (NUM_DIV - 1) / 2;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt1  <= 0;
        cnt2  <= 0;
        clk_div1 <= 0;
        clk_div2 <= 0;
    end else begin
        // Count for positive edges
        if (cnt1 < (NUM_DIV - 1)) begin
            cnt1 <= cnt1 + 1;
        end else begin
            cnt1 <= 0;
            // Toggle clk_div1 when cnt1 reaches NUM_DIV - 1
            if (cnt1 == HALF_DIV) begin
                clk_div1 <= ~clk_div1;
            end
        end

        // Count for negative edges
        if (cnt2 < (NUM_DIV - 1)) begin
            cnt2 <= cnt2 + 1;
        end else begin
            cnt2 <= 0;
            // Toggle clk_div2 when cnt2 reaches NUM_DIV - 1
            if (cnt2 == HALF_DIV) begin
                clk_div2 <= ~clk_div2;
            end
        end
    end
end

assign clk_div = clk_div1 | clk_div2;

endmodule