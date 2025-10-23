module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

// One-hot encoded states as 2-bit vector:
// 2'b01 = A (reset state), 2'b10 = B
reg [1:0] state, next_state;

localparam A = 2'b01;
localparam B = 2'b10;

// Next state combinational logic
always @(*) begin
    case (state)
        A: next_state = (x) ? B : A;
        B: next_state = B;
        default: next_state = A; // safe default
    endcase
end

// Sequential logic with asynchronous active-high reset
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= A;
    else
        state <= next_state;
end

// Mealy output logic:
// From FSM description:
//  - In A, z = x
//  - In B, z = ~x
assign z = (state == A) ? x : ~x;

endmodule