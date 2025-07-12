module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

    // Named state encoding for clarity
    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state;

    // Next state logic simplified: next_state = state XOR NOT(in)
    // Matches state transitions:
    // B(1): in=0 -> A(0), in=1 -> B(1)
    // A(0): in=0 -> B(1), in=1 -> A(0)
    wire next_state = state ^ ~in;

    // Asynchronous reset to state B
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else
            state <= next_state;
    end

    // Moore output equals current state
    assign out = state;

endmodule