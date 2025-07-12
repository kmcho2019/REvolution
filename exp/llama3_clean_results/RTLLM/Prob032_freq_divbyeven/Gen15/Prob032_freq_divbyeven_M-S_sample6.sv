// Simplified frequency divider module by even numbers
module freq_diveven #(
    parameter NUM_DIV = 2  // Even number division factor
) (
    input clk,        // Input clock signal
    input rst_n,      // Active-low reset signal
    output reg clk_div // Divided clock output signal
);

reg [3:0] cnt;  // 4-bit counter for clock cycle tracking

// Sequential logic for counter update and clock division
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 4'b0;
        clk_div <= 1'b0;
    end else if (cnt == (NUM_DIV / 2 - 1)) begin
        cnt <= 4'b0;
        clk_div <= ~clk_div;
    end else begin
        cnt <= cnt + 1;
    end
end

endmodule