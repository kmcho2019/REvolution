module TopModule (
    input clk,
    input j,
    input k,
    output reg Q
);

always @(posedge clk) begin
    Q <= (j & ~k) |        // Set when J=1,K=0
         (~j & ~k & Q) |   // Hold when J=0,K=0
         (j & k & ~Q);     // Toggle when J=1,K=1
end

endmodule