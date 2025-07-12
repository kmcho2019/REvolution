// Module JC_counter: 64-bit Johnson counter
module JC_counter(
    input clk, // Clock signal
    input rst_n, // Active-low reset signal
    output reg [63:0] Q // 64-bit register representing the current count value
);

// Continuous assignment for normal operation
assign Q_next = {~Q[0], Q[63:1]};

// Always block: synchronous operation for reset
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the counter to 0
        Q <= 64'd0;
    end else begin
        // Update Q based on the next value
        Q <= Q_next;
    end
end

endmodule