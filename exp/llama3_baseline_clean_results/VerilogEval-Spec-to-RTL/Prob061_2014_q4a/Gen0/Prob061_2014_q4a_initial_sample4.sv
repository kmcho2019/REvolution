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
        // Load value from R when L is asserted
        Q <= R;
    end else if (E) begin
        // Shift in value from previous stage when E is asserted
        Q <= w;
    end
end

endmodule