module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

    // One-hot encoding: state_A = 2'b01, state_B = 2'b10
    localparam [1:0] A = 2'b01;
    localparam [1:0] B = 2'b10;

    reg [1:0] state, next_state;

    // State register with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;   // Reset to state A
        else
            state <= next_state;
    end

    // Next state logic
    // From A: if x=1 go to B else stay in A
    // From B: stay in B
    always @(*) begin
        if (state == A)
            next_state = x ? B : A;
        else
            next_state = B;
    end

    // Output z combinationally derived for Mealy FSM
    // z = (state_A & x) | (state_B & ~x)
    assign z = (state[0] & x) | (state[1] & ~x);

endmodule