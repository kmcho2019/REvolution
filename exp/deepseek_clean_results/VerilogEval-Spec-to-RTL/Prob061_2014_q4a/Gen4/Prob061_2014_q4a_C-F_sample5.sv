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
        Q <= R;  // Highest priority: parallel load
    end
    else if (E) begin
        Q <= w;  // Second priority: shift operation
    end
    else begin
        Q <= Q;  // Explicit hold (helps synthesis optimization)
    end
end

endmodule