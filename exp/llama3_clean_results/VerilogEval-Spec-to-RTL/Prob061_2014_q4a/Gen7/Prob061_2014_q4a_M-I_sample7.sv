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
        Q <= R; // Load value R when L is high
    end else if (E) begin
        Q <= w; // Shift in value w when E is high and L is low
    end else begin
        // When neither L nor E is high, hold the previous value of Q
        // This is implicit in Verilog as non-blocking assignments only update
        // at the end of the clock cycle, so no explicit statement is needed here.
    end
end

endmodule