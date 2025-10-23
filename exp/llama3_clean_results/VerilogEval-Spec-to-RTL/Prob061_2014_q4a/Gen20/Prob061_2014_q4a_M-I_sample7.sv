module TopModule(
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

always @(posedge clk) begin
    // Using a single assignment statement with combined conditions
    Q <= (L) ? R : (E) ? w : Q;
end

endmodule