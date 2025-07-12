module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

    // One-hot state encoding parameters
    localparam A = 2'b01;
    localparam B = 2'b10;

    reg [1:0] state, next_state;

    // State register with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else
            state <= next_state;
    end

    // Next state logic simplified:
    // From A: if x=1 go to B else stay in A
    // From B: stay in B
    always @(*) begin
        if (state == A)
            next_state = x ? B : A;
        else
            next_state = B; // B stable
    end

    // Output z combinational as direct logic expression from state bits and x
    // From FSM spec:
    //  state A: z = x
    //  state B: z = ~x
    // Using state bits explicitly: state[0] is A, state[1] is B (one-hot)
    assign z = (state[0] &  x) |  // A state and x=1
               (state[1] & ~x);   // B state and x=0

endmodule