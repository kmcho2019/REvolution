module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

// State encoding (one-hot): 2'b01 = A, 2'b10 = B
reg [1:0] state, next_state;

// State definitions for clarity
localparam A = 2'b01;
localparam B = 2'b10;

// Next state combinational logic
always @(*) begin
    case (state)
        A: next_state = x ? B : A;
        B: next_state = B;
        default: next_state = A; // safety fallback
    endcase
end

// Sequential logic with asynchronous active-high reset
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= A;
    else
        state <= next_state;
end

// Mealy output logic: output depends on state and input
// According to the FSM:
// A + x=0 => z=0
// A + x=1 => z=1
// B + x=0 => z=1
// B + x=1 => z=0
assign z = (state == A) ? x : ~x;

endmodule