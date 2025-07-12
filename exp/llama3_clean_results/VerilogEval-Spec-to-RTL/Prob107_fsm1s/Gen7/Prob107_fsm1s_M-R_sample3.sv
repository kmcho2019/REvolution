module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

parameter RESET_STATE = 0; // Define the reset state as a parameter

reg state; // Using a 1-bit register to represent the state
reg next_state; // Using a 1-bit register to represent the next state

assign next_state = (state == 0)? ~in : in; // Define the next state logic

always @(posedge clk) begin
    if(reset) begin
        state <= RESET_STATE; // Reset the state to the defined reset state
    end else begin
        state <= next_state; // Update the state with the next state
    end
end

assign out = ~state; // Output is 1 in state B (0) and 0 in state A (1)

endmodule