module freq_diveven (
    input clk,
    input rst_n,
    output reg clk_div
);

parameter NUM_DIV = 6;  // Division factor (must be even)

// Validate parameter
initial begin
    if (NUM_DIV % 2 != 0) begin
        $error("NUM_DIV must be even (current value: %0d)", NUM_DIV);
    end
end

// Calculate required counter width
localparam CNT_WIDTH = $clog2(NUM_DIV/2);
localparam CNT_MAX = NUM_DIV/2 - 1;

reg [CNT_WIDTH-1:0] cnt;  // Optimized width counter

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 0;
        clk_div <= 0;
    end else if (cnt == CNT_MAX) begin
        cnt <= 0;
        clk_div <= ~clk_div;  // Toggle output
    end else begin
        cnt <= cnt + 1;
    end
end

endmodule