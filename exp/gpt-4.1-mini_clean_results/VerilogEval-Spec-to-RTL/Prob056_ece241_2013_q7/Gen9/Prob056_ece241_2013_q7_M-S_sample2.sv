module TopModule (
    input clk,
    input j,
    input k,
    output reg Q
);

wire next_Q;

assign next_Q = (j & ~k) | (j & k & ~Q) | (Q & ~j & ~k);

always @(posedge clk) begin
    Q <= next_Q;
end

endmodule