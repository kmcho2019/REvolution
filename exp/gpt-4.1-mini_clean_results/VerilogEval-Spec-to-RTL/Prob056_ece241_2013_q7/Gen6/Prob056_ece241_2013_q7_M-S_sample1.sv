module TopModule (
    input clk,
    input j,
    input k,
    output reg Q
);

always @(posedge clk) begin
    Q <= (j & ~k) | (Q & ~(j ^ k));
end

endmodule