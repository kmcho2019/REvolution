module TopModule(
    input  logic clk,
    input  logic areset,
    input  logic j,
    input  logic k,
    output logic out
);

// Define the states
enum logic [0:0] {OFF, ON} state, next_state;

// State register
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= OFF;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always_comb begin
    case(state)
        OFF: next_state = j ? ON : OFF;
        ON:  next_state = k ? OFF : ON;
        default: next_state = OFF;
    endcase
end

// Output logic
assign out = (state == ON) ? 1'b1 : 1'b0;

endmodule