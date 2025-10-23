module TopModule(
    input clk,
    input j,
    input k,
    output reg Q
);

always @(posedge clk) begin
    if (~j & ~k)       // J=0, K=0 -> hold state
        Q <= Q;
    else if (~j & k)   // J=0, K=1 -> reset
        Q <= 1'b0;
    else if (j & ~k)   // J=1, K=0 -> set
        Q <= 1'b1;
    else               // J=1, K=1 -> toggle
        Q <= ~Q;
end

endmodule