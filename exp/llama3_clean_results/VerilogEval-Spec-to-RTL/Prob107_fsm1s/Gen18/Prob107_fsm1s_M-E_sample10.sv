module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

// Define the look-up tables for next state and output
reg [1:0] next_state_lut[2:0]; // 2 bits for state, 1 bit for input
reg [1:0] out_lut[2:0];

initial begin
    // Initialize the look-up tables based on the state machine definition
    next_state_lut[0] = 2'b01; // State B, in = 0 -> State A
    next_state_lut[1] = 2'b00; // State B, in = 1 -> State B
    next_state_lut[2] = 2'b00; // State A, in = 0 -> State B
    next_state_lut[3] = 2'b10; // State A, in = 1 -> State A

    out_lut[0] = 2'b01; // State B, out = 1
    out_lut[1] = 2'b01; // State B, out = 1
    out_lut[2] = 2'b00; // State A, out = 0
    out_lut[3] = 2'b00; // State A, out = 0
end

reg [1:0] state; // Current state

always @(posedge clk) begin
    if(reset) begin
        state <= 2'b00; // Reset to state B
    end else begin
        // Use the look-up table to determine the next state
        reg [1:0] lut_index = {state, in};
        state <= next_state_lut[lut_index][1:0];
    end
end

assign out = (state == 2'b00)? 1'b1 : 1'b0; // Output logic based on state

endmodule