module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

// Define the reset state as a parameter
localparam RESET_STATE = 1'b0;

// Define states using one-hot encoding
localparam STATE_B = 1'b0;
localparam STATE_A = 1'b1;

// State register
reg state;

// Define the next state logic using assign statements
reg next_state;
assign next_state = (state == STATE_B)? (in? STATE_B : STATE_A) : (in? STATE_A : STATE_B);

// Update the state using a single always block
always @(posedge clk) begin
    if(reset) begin
        state <= RESET_STATE; // Reset the state to the defined reset state
    end else begin
        state <= next_state; // Update the state with the next state
    end
end

// Output assignment based on current state
assign out = ~state; // Out is 1 in state B (0) and 0 in state A (1)

endmodule