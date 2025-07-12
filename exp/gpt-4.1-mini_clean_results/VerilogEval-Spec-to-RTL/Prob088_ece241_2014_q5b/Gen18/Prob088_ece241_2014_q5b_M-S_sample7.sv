module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

// One-hot encoded states in 2-bit register:
// state = 2'b01 => A
// state = 2'b10 => B
reg [1:0] state, next_state;

// Next state logic
always @(*) begin
    case (state)
        2'b01: next_state = x ? 2'b10 : 2'b01;  // A: if x=1 go to B else stay A
        2'b10: next_state = 2'b10;               // B: stay B regardless of x
        default: next_state = 2'b01;             // default to A for safety
    endcase
end

// State register with asynchronous active-high reset
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= 2'b01; // reset to A
    else
        state <= next_state;
end

// Mealy output logic: z depends on current state and input x
always @(*) begin
    case (state)
        2'b01: z = x;    // in A, z = x
        2'b10: z = ~x;   // in B, z = ~x
        default: z = 1'b0; // default output
    endcase
end

endmodule