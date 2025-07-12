// Define the states as an enum
enum logic [0:0] {OFF, ON} state, next_state;

// TopModule implementation
module TopModule(
    input  logic clk,
    input  logic areset,
    input  logic j,
    input  logic k,
    output logic out
);

// Combinational logic for next state
always_comb begin
    case(state)
        OFF: next_state = (j == 1'b1) ? ON : OFF;
        ON:  next_state = (k == 1'b1) ? OFF : ON;
        default: next_state = OFF; // default to OFF for invalid states
    endcase
end

// Sequential logic for state update and asynchronous reset
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= OFF;
    end else begin
        state <= next_state;
    end
end

// Output logic based on the current state
always_comb begin
    case(state)
        OFF: out = 1'b0;
        ON:  out = 1'b1;
        default: out = 1'b0; // default output for invalid states
    endcase
end

endmodule