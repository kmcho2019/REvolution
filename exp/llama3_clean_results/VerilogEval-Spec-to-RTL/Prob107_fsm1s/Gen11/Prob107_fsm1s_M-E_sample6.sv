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

// LUTs for next state and output
reg [1:0] lut_next_state, lut_out;

// Initialize LUTs
initial begin
    // Next state LUT
    lut_next_state[0] = STATE_B; // STATE_B, in=0
    lut_next_state[1] = STATE_B; // STATE_B, in=1
    lut_next_state[2] = STATE_A; // STATE_A, in=0
    lut_next_state[3] = STATE_A; // STATE_A, in=1

    // Output LUT
    lut_out[0] = 1'b1; // STATE_B, out=1
    lut_out[1] = 1'b1; // STATE_B, out=1
    lut_out[2] = 1'b0; // STATE_A, out=0
    lut_out[3] = 1'b0; // STATE_A, out=0
end

// Update the state using a single always block
always @(posedge clk) begin
    if(reset) begin
        state <= RESET_STATE; // Reset the state to the defined reset state
    end else begin
        state <= lut_next_state[{state, in}]; // Update the state with the next state from LUT
    end
end

// Output assignment based on current state and input
assign out = lut_out[{state, in}]; // Out is determined from LUT

endmodule