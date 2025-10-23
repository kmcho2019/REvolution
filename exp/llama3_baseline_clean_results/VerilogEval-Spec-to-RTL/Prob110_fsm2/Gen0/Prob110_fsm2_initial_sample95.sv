module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output reg out
);

// Define the states
enum logic [0:0] {OFF, ON} state, next_state;

// Combinational logic to determine the next state
always @(*) begin
    case (state)
        OFF: next_state = (j) ? ON : OFF;
        ON:  next_state = (k) ? OFF : ON;
        default: next_state = OFF;
    endcase
end

// Sequential logic to update the state and output
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= OFF;
        out <= 0;
    end else begin
        state <= next_state;
        out <= (state == ON) ? 1 : 0;
    end
end

endmodule