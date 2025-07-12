module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

// One-hot encoded state vector: state[0] = A, state[1] = B
reg [1:0] state, next_state;

// Next state combinational logic
always @(*) begin
    case (state)
        2'b01: // state A
            if (x)
                next_state = 2'b10; // move to B
            else
                next_state = 2'b01; // stay in A
        2'b10: // state B
            next_state = 2'b10; // stay in B regardless of x
        default: 
            next_state = 2'b01; // default/reset to A
    endcase
end

// Sequential logic with asynchronous active-high reset
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= 2'b01; // reset to A
    else
        state <= next_state;
end

// Mealy output: z depends on state and input x
// From table:
// A: x=0->z=0, x=1->z=1
// B: x=0->z=1, x=1->z=0
assign z = (state[0] & x) | (state[1] & ~x);

endmodule