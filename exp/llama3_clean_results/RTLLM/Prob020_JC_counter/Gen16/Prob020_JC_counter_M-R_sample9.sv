// Module JC_counter: 64-bit Johnson counter
module JC_counter(
    input clk, // Clock signal
    input rst_n, // Active-low reset signal
    output reg [63:0] Q // 64-bit register representing the current count value
);

// Internal signal to hold the new value of Q
reg [63:0] next_Q;

// Combinational logic to calculate the next state of Q
always @* begin
    if (~Q[0]) begin // If the least significant bit is 0
        next_Q = {1'b1, Q[63:1]}; // Shift right and append 1
    end else begin
        next_Q = {1'b0, Q[63:1]}; // Shift right and append 0
    end
end

// Sequential logic to update Q on the rising edge of clk or falling edge of rst_n
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Reset condition
        Q <= '0; // Set all bits to 0 for reset
    end else begin // Normal operation
        Q <= next_Q; // Update Q with the calculated next state
    end
end

endmodule