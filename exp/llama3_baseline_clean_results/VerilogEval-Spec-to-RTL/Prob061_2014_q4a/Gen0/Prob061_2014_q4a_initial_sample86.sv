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
        // Load R into Q when L is asserted
        Q <= R;
    end else if (E) begin
        // Shift in w when E is asserted
        Q <= w;
    end else begin
        // Hold the current value of Q
        Q <= Q;
    end
end

endmodule