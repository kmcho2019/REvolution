module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

// Define states using enum for better readability
enum logic [0:0] {OFF, ON} state, next_state;

// Next state logic using combinational logic
always_comb begin
    case (state)
        OFF: next_state = j ? ON : OFF;
        ON:  next_state = ~k ? ON : OFF;
        default: next_state = OFF; // Default to OFF for invalid states
    endcase
end

// State register with synchronous reset
always_ff @(posedge clk) begin
    if (reset) begin
        state <= OFF; // Reset to OFF state
    end else begin
        state <= next_state; // Update state based on next state logic
    end
end

// Output logic based on current state
assign out = (state == ON); // Directly assign output based on state

endmodule