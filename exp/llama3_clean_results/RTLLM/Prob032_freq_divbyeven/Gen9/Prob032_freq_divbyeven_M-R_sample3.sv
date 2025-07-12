// Refactored freq_diveven Module
module freq_diveven #(
    parameter NUM_DIV = 8, // Must be an even number
    parameter COUNTER_BITS = 4 // Number of bits for the counter
)(
    input clk,
    input rst_n,
    output reg clk_div
);

reg [COUNTER_BITS-1:0] cnt; // Counter register

// Separate always block for counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 0;
    end else if (cnt == (NUM_DIV / 2 - 1)) begin
        cnt <= 0;
    end else begin
        cnt <= cnt + 1;
    end
end

// Separate always block for clk_div toggle logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div <= 0;
    end else if (cnt == (NUM_DIV / 2 - 1)) begin
        clk_div <= ~clk_div; // Toggle clk_div
    end
end

endmodule