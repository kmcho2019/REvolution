module TopModule(
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

reg D;

assign D = (L)? R : (E)? w : Q;

always @(posedge clk) begin
    Q <= D;
end

endmodule