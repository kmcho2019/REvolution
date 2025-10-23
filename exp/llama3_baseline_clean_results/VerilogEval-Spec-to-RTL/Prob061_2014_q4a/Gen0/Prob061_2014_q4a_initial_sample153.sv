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
        // Load R into the flip-flop when L is asserted
        Q <= R;
    end else if (E) begin
        // Shift in w into the flip-flop when E is asserted and L is not
        Q <= w;
    end else begin
        // If neither L nor E is asserted, maintain the current value of Q
        Q <= Q;
    end
end

endmodule