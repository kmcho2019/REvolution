module TopModule (
    input  clk,
    input  w,
    input  R,
    input  E,
    input  L,
    output reg Q
);

    reg next_Q;

    // Combinational next-state logic
    always @(*) begin
        if (L)
            next_Q = R;
        else if (E)
            next_Q = w;
        else
            next_Q = Q;
    end

    // Sequential update on clock edge
    always @(posedge clk) begin
        Q <= next_Q;
    end

endmodule