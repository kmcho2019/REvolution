module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

// Enum for states
enum logic [0:0] {OFF, ON} state, next_state;

// Combinational logic for next state
always_comb begin
    case(state)
        OFF: next_state = (j) ? ON : OFF;
        ON:  next_state = (k) ? OFF : ON;
        default: next_state = OFF;
    endcase
end

// Sequential logic for state update
always_ff @(posedge clk) begin
    if(reset) begin
        state <= OFF;
    end else begin
        state <= next_state;
    end
end

// Output logic
assign out = (state == ON) ? 1'b1 : 1'b0;

endmodule