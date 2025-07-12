module freq_divbyodd #(
    parameter NUM_DIV = 5  // Default divisor value
)(
    input  clk,
    input  rst_n,
    output clk_div
);

reg [31:0] cnt1;  // Counter for positive edge
reg [31:0] cnt2;  // Counter for negative edge
reg       clk_div1;  // Divided clock for positive edge
reg       clk_div2;  // Divided clock for negative edge

// Determine half of NUM_DIV
localparam HALF_DIV = (NUM_DIV - 1) / 2;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin  // Active low reset
        cnt1  <= 0;
        cnt2  <= 0;
        clk_div1 <= 0;
        clk_div2 <= 0;
    end else begin
        // Count rising edge
        if (cnt1 == NUM_DIV - 1) begin
            cnt1 <= 0;
            // Toggle clk_div1 when cnt1 reaches half of NUM_DIV
            if (HALF_DIV == (NUM_DIV - 1) / 2) begin
                clk_div1 <= ~clk_div1;
            end
        end else begin
            cnt1 <= cnt1 + 1;
        end

        // Count falling edge
        if (cnt2 == NUM_DIV - 1) begin
            cnt2 <= 0;
            // Toggle clk_div2 when cnt2 reaches half of NUM_DIV
            if (HALF_DIV == (NUM_DIV - 1) / 2) begin
                clk_div2 <= ~clk_div2;
            end
        end else begin
            cnt2 <= cnt2 + 1;
        end
    end
end

// Final divided clock output is OR of clk_div1 and clk_div2
assign clk_div = clk_div1 | clk_div2;

endmodule