module TopModule (
    input  clk,
    input  w,
    input  R,
    input  E,
    input  L,
    output reg Q
);

    wire ce = L | E;
    reg Q_next;

    always @(*) begin
        if (L)
            Q_next = R;
        else if (E)
            Q_next = w;
        else
            Q_next = Q;
    end

    always @(posedge clk) begin
        if (ce)
            Q <= Q_next;
    end

endmodule