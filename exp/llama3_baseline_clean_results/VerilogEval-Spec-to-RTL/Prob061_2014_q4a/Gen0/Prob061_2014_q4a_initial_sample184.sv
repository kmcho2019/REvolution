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
        Q <= R; // Load R when L is asserted
    end else if (E) begin
        Q <= w; // Shift w when E is asserted and L is not
    end
end

endmodule