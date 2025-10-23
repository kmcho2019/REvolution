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
        // Load R when L is asserted
        Q <= R;
    end else if (E) begin
        // Shift w from previous stage when E is asserted
        Q <= w;
    end else begin
        // Hold the current value of Q when neither L nor E is asserted
        Q <= Q;
    end
end

endmodule