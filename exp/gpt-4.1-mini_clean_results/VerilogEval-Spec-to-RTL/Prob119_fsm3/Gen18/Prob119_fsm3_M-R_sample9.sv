module TopModule(
    input  wire clk,
    input  wire areset,
    input  wire in,
    output wire out
);

    // One-hot state encoding: 4 states using 4 bits
    localparam A = 4'b0001,
               B = 4'b0010,
               C = 4'b0100,
               D = 4'b1000;

    reg [3:0] state, next_state;

    // Next state logic as combinational continuous assignments
    // next_state signals are one-hot encoded states, assigned with combinational logic
    wire in_bar = ~in;

    assign next_state =
        (state == A) ? (in_bar ? A : B) :
        (state == B) ? (in_bar ? C : B) :
        (state == C) ? (in_bar ? A : D) :
        (state == D) ? (in_bar ? C : B) :
        A;  // default reset to A

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else
            state <= next_state;
    end

    // Output logic: Moore output depends only on state D
    assign out = state[3];  // D encoded as highest bit

endmodule