module freq_diveven (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

parameter NUM_DIV = 4; // Must be even number (2, 4, 6, ...)

// Validate parameter (synthesis-time check)
initial begin
    if (NUM_DIV[0] != 0) begin
        $error("NUM_DIV must be even number");
    end
end

// Calculate required counter width
localparam CNT_WIDTH = $clog2(NUM_DIV/2);
localparam CNT_MAX = (NUM_DIV/2) - 1;

reg [CNT_WIDTH-1:0] cnt;

// Combined counter and clock divider logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 0;
        clk_div <= 0;
    end else begin
        if (cnt == CNT_MAX) begin
            cnt <= 0;
            clk_div <= ~clk_div;
        end else begin
            cnt <= cnt + 1;
        end
    end
end

endmodule