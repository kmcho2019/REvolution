// Define the states as enumerations
enum logic [0:0] {OFF, ON} state, next_state;

module TopModule(
    input  clk,    // clock
    input  areset, // asynchronous reset
    input  j,      // input j
    input  k,      // input k
    output out     // output
);

// Next state logic
always_comb begin
    case (state)
        OFF: next_state = (j) ? ON : OFF;
        ON:  next_state = (k) ? OFF : ON;
        default: next_state = OFF;
    endcase
end

// State register update with asynchronous reset
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= OFF;
    end else begin
        state <= next_state;
    end
end

// Output logic directly from state
assign out = (state == ON) ? 1'b1 : 1'b0;

endmodule