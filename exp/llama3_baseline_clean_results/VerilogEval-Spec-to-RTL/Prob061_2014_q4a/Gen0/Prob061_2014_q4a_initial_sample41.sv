module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

always @(posedge clk) begin
    if (L) begin
        // Load R into Q when L is high
        Q <= R;
    end else if (E) begin
        // Shift w to Q when E is high
        Q <= w;
    end else begin
        // Hold the current value of Q when E and L are low
        Q <= Q;
    end
end

endmodule