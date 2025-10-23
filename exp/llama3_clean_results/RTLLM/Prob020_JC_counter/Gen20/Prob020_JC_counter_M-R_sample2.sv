// Module JC_counter: 64-bit Johnson counter
module JC_counter(
    input clk,      // Clock signal
    input rst_n,    // Active-low reset signal
    output reg [63:0] Q  // 64-bit register representing the current count value
);

// Combinational logic to determine the next state of Q
reg [63:0] next_Q;
always @* begin
    if (~rst_n) next_Q = 64'd0; // Reset condition
    else next_Q = {Q[0]? 1'b0 : 1'b1, Q[63:1]}; // Update Q based on Q[0]
end

// Sequential logic to update Q at the rising edge of the clock
always @(posedge clk) begin
    Q <= next_Q;
end

endmodule