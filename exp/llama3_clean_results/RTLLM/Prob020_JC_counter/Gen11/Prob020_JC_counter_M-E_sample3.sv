// Module JC_counter: 64-bit Johnson counter
module JC_counter(
    input clk, // Clock signal
    input rst_n, // Active-low reset signal
    output reg [63:0] Q // 64-bit register representing the current count value
);

// Internal signal to store the next state of Q
reg [63:0] next_Q;

// Control signal to determine the next most significant bit
reg ctrl;

// Always block: combinational logic for next state
always @* begin
    // Determine the control signal based on the least significant bit of Q
    ctrl = ~Q[0];
    
    // Calculate the next state of Q
    next_Q = {ctrl, Q[63:1]};
end

// Always block: synchronous operation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) Q <= 64'd0;
    else Q <= next_Q;
end

endmodule