module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire in,
    output reg  out
);

    // State encoding for readability
    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state;

    // Minimal next-state logic using XOR-based expression
    wire next_state = state ^ ~in;

    // Clock enable: update state only if next_state differs from current state
    wire ce = (next_state != state);

    // State register with asynchronous reset to B and clock enable
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else if (ce)
            state <= next_state;
    end

    // Moore machine output: depends only on state
    always @(*) begin
        case(state)
            A: out = 1'b0;
            B: out = 1'b1;
            default: out = 1'b1; // safe default to B's output
        endcase
    end

endmodule