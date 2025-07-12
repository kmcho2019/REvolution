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
        // Load the value from input R when L is high
        Q <= R;
    end else if (E) begin
        // Shift the value from the previous stage when E is high
        Q <= w;
    end
end

endmodule