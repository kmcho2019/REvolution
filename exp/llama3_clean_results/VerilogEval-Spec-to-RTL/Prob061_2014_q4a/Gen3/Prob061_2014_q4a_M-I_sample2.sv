module TopModule(
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

always @(posedge clk) begin
    Q <= L ? R : (E && !L) ? w : Q;
end

endmodule