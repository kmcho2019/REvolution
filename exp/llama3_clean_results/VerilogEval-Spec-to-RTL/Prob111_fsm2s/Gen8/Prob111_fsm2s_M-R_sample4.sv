module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

// Define the states as an enum
enum logic [0:0] { OFF, ON } state, next_state;

// Combinational logic for next state
always_comb begin
    case (state)
        OFF: next_state = j? ON : OFF;
        ON:  next_state = ~k? ON : OFF;
        default: next_state = OFF;
    endcase
end

// Sequential logic for state update
always_ff @(posedge clk) begin
    if (reset) begin
        state <= OFF; // Reset to OFF state
    end else begin
        state <= next_state;
    end
end

// Output is determined by the current state
assign out = (state == ON)? 1'b1 : 1'b0;

endmodule