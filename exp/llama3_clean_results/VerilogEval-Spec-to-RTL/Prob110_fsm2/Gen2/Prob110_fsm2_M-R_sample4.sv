module TopModule(
    input        clk,    // clock
    input        areset, // asynchronous reset
    input        j,      // input j
    input        k,      // input k
    output logic out     // output
);

// Define states as enumerations
typedef enum logic [0:0] {OFF, ON} state_t;

state_t state, next_state; // current and next state

// Combinational logic for next state
always_comb begin
    case (state)
        OFF: next_state = (j) ? ON : OFF;
        ON:  next_state = (k) ? OFF : ON;
        default: next_state = OFF;
    endcase
end

// Sequential logic with asynchronous reset
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= OFF; // Reset to OFF state
    end else begin
        state <= next_state; // Update state
    end
end

// Output logic directly from state
assign out = (state == ON) ? 1'b1 : 1'b0;

endmodule