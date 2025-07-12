module TopModule(
    input  clk,    // clock
    input  areset, // asynchronous reset
    input  j,      // input j
    input  k,      // input k
    output out     // output
);

reg [1:0] current_state; // current state (2 bits to allow for LUT encoding)

// LUT-based next state and output logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= 2'b00; // Reset to state OFF
    end else begin
        case ({current_state, j, k})
            3'b000, 3'b001: current_state <= 2'b00; // Stay in OFF state if j=0
            3'b010: current_state <= 2'b01; // Transition to ON state if j=1
            3'b100, 3'b101: current_state <= 2'b01; // Stay in ON state if k=0
            3'b110: current_state <= 2'b00; // Transition to OFF state if k=1
            default: current_state <= 2'b00; // Default to OFF state
        endcase
    end
end

// Output logic directly from state
assign out = current_state[0]; // Assuming the output is based on the least significant bit of the state

endmodule