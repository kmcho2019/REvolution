module TopModule (
    input  clk,
    input  w,
    input  R,
    input  E,
    input  L,
    output reg Q
);

    wire enable = L | E;

    always @(posedge clk) begin
        if (L)
            Q <= R;
        else if (E)
            Q <= w;
        else
            Q <= Q;  // hold state, can omit but included for clarity
    end

endmodule