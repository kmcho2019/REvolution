module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

parameter RESET_STATE = 0; // Define the reset state as a parameter

reg state; // 1-bit state variable
reg next_state; // 1-bit next state variable

assign next_state = (state == 0)? ~in : in; // Define the next state logic

always @(posedge clk) begin
    if(reset) begin // Synchronous reset
        state <= RESET_STATE; // Reset to the defined reset state
    end else begin
        state <= next_state; // Update state based on next state
    end
end

assign out = ~state; // Output is directly related to the state

endmodule