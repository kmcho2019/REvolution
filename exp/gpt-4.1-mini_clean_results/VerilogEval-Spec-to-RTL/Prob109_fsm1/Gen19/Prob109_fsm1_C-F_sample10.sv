module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire in,
    output wire out
);

    // State encoding for clarity
    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state;

    // Next state logic derived from FSM diagram:
    // B(1) --0--> A(0), B(1) --1--> B(1)
    // A(0) --0--> B(1), A(0) --1--> A(0)
    // next_state = state XOR (~in)
    wire next_state = state ^ ~in;

    // Sequential logic with asynchronous reset to state B
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else
            state <= next_state;
    end

    // Moore output equals current state
    assign out = state;

endmodule