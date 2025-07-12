module TopModule (
    input  clk,
    input  j,
    input  k,
    output reg Q
);

always @(posedge clk) begin
    if (j == 0 && k == 0)
        Q <= Q;        // hold
    else if (j == 0 && k == 1)
        Q <= 0;        // reset
    else if (j == 1 && k == 0)
        Q <= 1;        // set
    else // j==1 && k==1
        Q <= ~Q;       // toggle
end

endmodule