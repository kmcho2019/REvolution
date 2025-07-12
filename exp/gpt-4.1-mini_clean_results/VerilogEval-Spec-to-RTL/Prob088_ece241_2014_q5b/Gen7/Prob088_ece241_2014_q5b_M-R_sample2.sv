module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

    // State encoding: one-hot in a 2-bit vector [state_B, state_A]
    reg [1:0] state, next_state;

    localparam A = 2'b01;
    localparam B = 2'b10;

    // Asynchronous reset and state update
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else
            state <= next_state;
    end

    // Next state combinational logic
    // From FSM:
    // A --x=0--> A
    // A --x=1--> B
    // B --x=0--> B
    // B --x=1--> B
    assign next_state = (state == A) ? (x ? B : A) :
                        (state == B) ? B :
                        A; // default safe state

    // Mealy output: depends on state and input
    // A: z = x
    // B: z = ~x
    assign z = (state == A) ? x : ~x;

endmodule