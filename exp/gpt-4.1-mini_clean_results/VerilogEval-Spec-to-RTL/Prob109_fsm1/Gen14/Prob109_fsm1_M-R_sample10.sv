module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire in,
    output wire out
);

    // State encoding
    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state;
    wire next_state;

    // Next state logic as combinational continuous assignment
    // Following transitions:
    // B (1) --0--> A
    // B (1) --1--> B
    // A (0) --0--> B
    // A (0) --1--> A
    assign next_state = (state == B) ? (in ? B : A) : (in ? A : B);

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else
            state <= next_state;
    end

    // Moore output directly from current state
    assign out = state;

endmodule