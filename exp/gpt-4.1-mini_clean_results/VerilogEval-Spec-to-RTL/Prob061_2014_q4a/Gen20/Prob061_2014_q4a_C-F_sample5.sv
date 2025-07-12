module TopModule (
    input  clk,
    input  w,
    input  R,
    input  E,
    input  L,
    output reg Q
);

    wire enable = L | E;
    reg  next_Q;

    // Explicit next state logic with priority: load > shift > hold
    always @(*) begin
        next_Q = (L) ? R :
                 (E) ? w : Q;
    end

    // Register update only when enable asserted, avoiding unnecessary toggling
    always @(posedge clk) begin
        if (enable)
            Q <= next_Q;
        // else hold current state implicitly
    end

endmodule