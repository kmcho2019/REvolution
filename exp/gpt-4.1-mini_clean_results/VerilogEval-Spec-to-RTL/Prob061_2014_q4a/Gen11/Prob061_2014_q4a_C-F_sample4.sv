module TopModule (
    input  clk,
    input  w,
    input  R,
    input  E,
    input  L,
    output reg Q
);

    reg next_Q;

    // Combinational next state logic with prioritized if-else
    always @(*) begin
        if (L)
            next_Q = R;
        else if (E)
            next_Q = w;
        else
            next_Q = Q;
    end

    // Sequential update only when load or shift enable is asserted
    always @(posedge clk) begin
        if (L || E)
            Q <= next_Q;
    end

endmodule