module TopModule(
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q = 0 // Initialize Q to avoid potential issues with uninitialized registers
);

always @(posedge clk) begin
    Q <= (L) ? R : (E) ? w : Q;
end

endmodule