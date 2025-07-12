module TopModule(
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

reg load_val;

always @(posedge clk)
    if (L)
        load_val <= R;

always @(posedge clk)
    if (E)
        Q <= w;
    else if (L)
        Q <= load_val;
    else
        Q <= Q;

endmodule