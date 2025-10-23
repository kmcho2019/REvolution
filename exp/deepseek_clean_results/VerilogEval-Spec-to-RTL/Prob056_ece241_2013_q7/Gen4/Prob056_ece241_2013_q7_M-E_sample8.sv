module TopModule (
    input clk,
    input j,
    input k,
    output reg Q
);

always @(posedge clk) begin
    // Conditional set when J=1, conditional reset when K=1
    // The toggle case (J=1,K=1) becomes (~Q) automatically
    Q <= (Q | j) & (~k | Q);
end

endmodule