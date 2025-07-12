module TopModule(
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

always @(posedge clk) begin
    if (L) begin
        Q <= R;  // Load value from R when L is asserted
    end else if (E) begin
        Q <= w;  // Shift value from w when E is asserted
    end
end

endmodule