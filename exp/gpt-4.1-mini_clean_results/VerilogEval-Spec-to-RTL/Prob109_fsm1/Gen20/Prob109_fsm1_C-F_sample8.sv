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
    // Transition logic according to FSM diagram:
    // B (1) --0--> A
    // B (1) --1--> B
    // A (0) --0--> B
    // A (0) --1--> A
    assign next_state = (state == B) ? (in ? B : A) : (in ? A : B);

    // State register with asynchronous reset to B
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else
            state <= next_state;
    end

    // Output is Moore output directly from state
    assign out = state;

endmodule