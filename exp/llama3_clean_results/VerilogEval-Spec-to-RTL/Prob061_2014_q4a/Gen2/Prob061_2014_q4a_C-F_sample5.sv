module TopModule(
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

always @(posedge clk) begin
    // Using ternary operator for simplicity and potential area efficiency
    Q <= L ? R : (E ? w : Q);
end

endmodule