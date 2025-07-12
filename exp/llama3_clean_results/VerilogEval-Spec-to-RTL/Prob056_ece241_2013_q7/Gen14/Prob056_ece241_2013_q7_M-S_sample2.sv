module TopModule(
    input clk,
    input j,
    input k,
    output reg Q
);

always @(posedge clk) begin
    Q <= ~k ? (j ? 1'b1 : Q) : (~j ? 1'b0 : ~Q);
end

endmodule