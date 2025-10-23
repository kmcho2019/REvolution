module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output out
);

// Define states as enumeration values
enum logic [0:0] {OFF, ON} curr_state, next_state;

// Combinational logic to determine the next state
always_comb begin
    case (curr_state)
        OFF: next_state = (j == 1) ? ON : OFF;
        ON:  next_state = (k == 1) ? OFF : ON;
        default: next_state = OFF; // Default state
    endcase
end

// Sequential logic to update the current state
always_ff @(posedge clk) begin
    if (reset) begin
        curr_state <= OFF; // Synchronous reset to OFF state
    end else begin
        curr_state <= next_state;
    end
end

// Output logic
assign out = (curr_state == ON) ? 1'b1 : 1'b0;

endmodule