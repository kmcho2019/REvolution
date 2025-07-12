module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

// Define the states as an enumeration
enum logic [1:0] {
    OFF = 2'b00,
    ON  = 2'b01
} state, next_state;

// Combinational logic to determine the next state
always_comb begin
    case(state)
        OFF: next_state = (j) ? ON : OFF;
        ON:  next_state = (k) ? OFF : ON;
        default: next_state = OFF; // default to OFF
    endcase
end

// Sequential logic to update the current state on the rising edge of the clock
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin // asynchronous reset
        state <= OFF;
    end else begin
        state <= next_state;
    end
end

// Continuous assignment for the output based on the current state
assign out = (state == ON) ? 1'b1 : 1'b0;

endmodule