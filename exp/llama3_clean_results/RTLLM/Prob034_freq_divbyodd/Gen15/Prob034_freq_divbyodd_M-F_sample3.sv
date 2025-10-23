module freq_divbyodd #(
    parameter NUM_DIV = 5  // Odd divisor
) (
    input  wire        clk,
    input  wire        rst_n,
    output wire        clk_div
);

localparam CNT_WIDTH = $clog2(NUM_DIV);  // Dynamic counter width

reg [CNT_WIDTH-1:0] cnt1;  // Counter for rising edges
reg [CNT_WIDTH-1:0] cnt2;  // Counter for falling edges
reg        clk_div1;  // Clock divider for positive edges
reg        clk_div2;  // Clock divider for negative edges
reg        rising_edge;  // Flag for rising edge

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt1 <= 0;
        cnt2 <= 0;
        clk_div1 <= 1'b0;
        clk_div2 <= 1'b0;
        rising_edge <= 1'b0;
    end else begin
        // Update counters
        if (rising_edge) begin
            if (cnt1 < (NUM_DIV - 1) / 2) begin
                cnt1 <= cnt1 + 1;
            end else begin
                cnt1 <= 0;
                clk_div1 <= ~clk_div1;
            end
        end

        if (!rising_edge) begin
            if (cnt2 < (NUM_DIV - 1) / 2) begin
                cnt2 <= cnt2 + 1;
            end else begin
                cnt2 <= 0;
                clk_div2 <= ~clk_div2;
            end
        end

        rising_edge <= 1'b1;  // Set flag for rising edge
    end
end

always @(negedge clk or negedge rst_n) begin
    if (~rst_n) begin
        rising_edge <= 1'b0;
    end else begin
        rising_edge <= 1'b0;  // Clear flag for falling edge
    end
end

assign clk_div = clk_div1 | clk_div2;

endmodule