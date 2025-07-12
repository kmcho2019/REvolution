// Refactored frequency divider module
module freq_diveven #(
    parameter NUM_DIV = 2  // Even number division factor
) (
    input clk,        // Input clock signal
    input rst_n,      // Active-low reset signal
    output reg clk_div // Divided clock output signal
);

// Calculate the required counter width based on NUM_DIV
localparam CNT_WIDTH = $clog2(NUM_DIV);

reg [CNT_WIDTH-1:0] cnt;  // Counter

// Sequential logic for counter update
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 0;
    end else if (cnt == (NUM_DIV / 2 - 1)) begin
        cnt <= 0;
    end else begin
        cnt <= cnt + 1;
    end
end

// Combinational logic for divided clock output
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div <= 0;
    end else if (cnt == (NUM_DIV / 2 - 1)) begin
        clk_div <= ~clk_div;
    end
end

endmodule