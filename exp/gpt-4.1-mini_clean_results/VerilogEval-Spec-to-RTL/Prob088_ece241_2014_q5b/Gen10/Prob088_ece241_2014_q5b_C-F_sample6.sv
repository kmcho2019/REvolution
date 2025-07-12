module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

// One-hot encoded state vector: state[1:0]
// state = 2'b01 for state A
// state = 2'b10 for state B
reg [1:0] state, next_state;

// State bits for clarity
wire state_A = state[0];
wire state_B = state[1];

// Next state logic (one-hot FSM)
always @(*) begin
    case (state)
        2'b01: // State A
            if (x)
                next_state = 2'b10; // go to B if x=1
            else
                next_state = 2'b01; // stay in A if x=0
        2'b10: // State B
            next_state = 2'b10; // stay in B regardless of x
        default:
            next_state = 2'b01; // default to A for safety
    endcase
end

// Sequential logic with asynchronous active-high reset
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= 2'b01; // reset into state A
    else
        state <= next_state;
end

// Mealy output: z = (state_A && x) || (state_B && ~x)
assign z = (state_A & x) | (state_B & ~x);

endmodule