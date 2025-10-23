module TopModule (
    input  clk,
    input  w,
    input  R,
    input  E,
    input  L,
    output reg Q
);

    always @(posedge clk) begin
        if (L && (Q !== R))
            Q <= R;
        else if (E && (Q !== w))
            Q <= w;
        // else retain current Q without assignment to minimize toggling
    end

endmodule