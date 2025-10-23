module TopModule (
    input  clk,
    input  w,
    input  R,
    input  E,
    input  L,
    output reg Q
);

    wire ce = L | E;

    wire Q_next = L ? R : w;

    always @(posedge clk) begin
        if (ce)
            Q <= Q_next;
    end

endmodule