module TopModule (
    input  clk,
    input  w,
    input  R,
    input  E,
    input  L,
    output reg Q
);
    always @(posedge clk) 
        if (L || E)
            Q <= L ? R : w;
endmodule