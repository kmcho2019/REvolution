// Refactored implementation for frequency division by even numbers
module freq_diveven #(
    parameter NUM_DIV = 2  // Even number division factor
) (
    input clk,        // Input clock signal
    input rst_n,      // Active-low reset signal
    output reg clk_div // Divided clock output signal
);

// Calculate counter width based on NUM_DIV for accurate division
localparam CNT_WIDTH = $clog2(NUM_DIV);
reg [CNT_WIDTH-1:0] cnt;  // Counter to track clock cycles

// Combinational logic to determine when to toggle clk_div
assign clk_div = (cnt == (NUM_DIV / 2 - 1)) ? ~clk_div : clk_div;

// Sequential logic for counter update
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= '0;
        clk_div <= 1'b0;
    end else begin
        if (cnt == (NUM_DIV - 1)) begin
            cnt <= '0;
        end else begin
            cnt <= cnt + 1;
        end
    end
end

// Optional: Validate NUM_DIV as an even number
initial begin
    if (NUM_DIV % 2 != 0) begin
        $display("Error: NUM_DIV (%0d) must be an even number.", NUM_DIV);
        $finish;
    end
end

endmodule