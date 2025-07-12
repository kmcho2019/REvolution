module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

// One-hot encoded states in a 2-bit vector
localparam A = 2'b01;
localparam B = 2'b10;

reg [1:0] state, next_state;

// Next state logic
always @(*) begin
    case(state)
        A: next_state = (x) ? B : A;
        B: next_state = B;
        default: next_state = A; // default safe state
    endcase
end

// State register with asynchronous active-high reset
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= A;
    else
        state <= next_state;
end

// Mealy output depends on current state and input
assign z = (state == A) ? x : (~x);

endmodule