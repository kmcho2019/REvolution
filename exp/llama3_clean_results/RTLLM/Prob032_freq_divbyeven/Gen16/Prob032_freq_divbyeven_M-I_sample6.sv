// Improved frequency divider module by even numbers
module freq_diveven #(
    parameter NUM_DIV = 2  // Even number division factor
) (
    input clk,        // Input clock signal
    input rst_n,      // Active-low reset signal
    output reg clk_div // Divided clock output signal
);

// Dynamically determine the width of the counter based on NUM_DIV
localparam CNT_WIDTH = $clog2(NUM_DIV);

reg [CNT_WIDTH-1:0] cnt;  // Counter for clock cycle tracking

// Sequential logic for counter update and clock division
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset counter and divided clock output on active-low reset
        cnt <= {CNT_WIDTH{1'b0}};
        clk_div <= 1'b0;
    end else if (cnt == (NUM_DIV / 2 - 1)) begin
        // Reset counter and toggle divided clock output at specified limit
        cnt <= {CNT_WIDTH{1'b0}};
        clk_div <= ~clk_div;
    end else begin
        // Increment counter on each clock cycle
        cnt <= cnt + 1;
    end
end

endmodule