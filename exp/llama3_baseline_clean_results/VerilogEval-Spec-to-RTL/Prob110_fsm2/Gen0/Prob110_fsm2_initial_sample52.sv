module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

// Define the states
typedef enum {OFF, ON} state_t;

// Register to store the current state
state_t state;

// Combinational logic to determine the next state
always_comb begin
    state_t next_state;
    case(state)
        OFF: next_state = (j) ? ON : OFF;
        ON:  next_state = (k) ? OFF : ON;
        default: next_state = OFF; // default to OFF if state is unknown
    endcase
    assign out = (state == ON) ? 1'b1 : 1'b0; // output depends on current state
end

// Sequential logic to update the state
always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= OFF; // reset to OFF state
    end else begin
        state <= next_state; // update state at every clock cycle
    end
end

endmodule