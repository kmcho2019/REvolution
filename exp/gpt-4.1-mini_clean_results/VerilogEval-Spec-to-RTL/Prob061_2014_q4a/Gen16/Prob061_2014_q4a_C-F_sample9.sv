module TopModule (
    input  clk,
    input  w,
    input  R,
    input  E,
    input  L,
    output reg Q
);

    reg next_Q;
    wire enable;

    assign enable = L || E;

    // Combinational next state logic with priority: load > shift > hold
    always @(*) begin
        if (L)
            next_Q = R;
        else if (E)
            next_Q = w;
        else
            next_Q = Q;
    end

    // Sequential update only when enabled, avoiding unnecessary toggling
    always @(posedge clk) begin
        if (enable)
            Q <= next_Q;
        // else no assignment: register naturally holds value, no toggling
    end

endmodule