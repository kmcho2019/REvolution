module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

    // One-hot encoding states (2 bits)
    // A = 2'b01, B = 2'b10
    localparam [1:0] A = 2'b01;
    localparam [1:0] B = 2'b10;

    reg [1:0] state, next_state;

    // Asynchronous active-high reset: reset to state A
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else
            state <= next_state;
    end

    // Next state logic using direct one-hot bits
    always @(*) begin
        // From A: if x=1 -> B else A; from B: stay B
        // state[0] is A-hot bit, state[1] is B-hot bit
        next_state[0] = state[0] & (~x);
        next_state[1] = (state[0] & x) | state[1];
    end

    // Mealy output logic directly using one-hot bits and input x
    // From diagram:
    // A: z = x
    // B: z = ~x
    always @(*) begin
        z = (state[0] & x) | (state[1] & ~x);
    end

endmodule