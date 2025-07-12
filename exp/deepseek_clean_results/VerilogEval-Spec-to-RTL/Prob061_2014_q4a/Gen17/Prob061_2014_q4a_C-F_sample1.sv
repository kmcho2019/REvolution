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
        Q <= R;       // Highest priority: load
    end
    else if (E) begin
        Q <= w;       // Second priority: shift
    end
    // else retain Q (lowest priority, no power consumption)
end

endmodule