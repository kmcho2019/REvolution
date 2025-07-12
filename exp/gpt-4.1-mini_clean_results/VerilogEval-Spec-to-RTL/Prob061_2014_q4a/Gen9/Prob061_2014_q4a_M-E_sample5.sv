module TopModule (
    input  clk,
    input  w,
    input  R,
    input  E,
    input  L,
    output reg Q
);

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
        if (L || E)
            Q <= Q_next;
    end

endmodule