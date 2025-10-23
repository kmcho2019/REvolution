module TopModule (
    input  clk,
    input  w,
    input  R,
    input  E,
    input  L,
    output reg Q
);

    reg nextQ;

    always @(*) begin
        if (L)
            nextQ = R;
        else if (E)
            nextQ = w;
        else
            nextQ = Q;
    end

    always @(posedge clk) begin
        Q <= nextQ;
    end

endmodule