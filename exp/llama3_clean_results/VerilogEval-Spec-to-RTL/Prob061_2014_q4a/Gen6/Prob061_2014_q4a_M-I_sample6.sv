module TopModule(
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

always @(posedge clk)
    if (L)
        Q <= R;
    else if (E)
        Q <= w;
    // If neither L nor E is high, Q retains its value

endmodule