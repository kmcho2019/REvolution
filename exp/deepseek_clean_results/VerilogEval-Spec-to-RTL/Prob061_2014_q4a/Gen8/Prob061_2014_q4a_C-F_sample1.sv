module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

always @(posedge clk) begin
    if (L)        // Highest priority: load
        Q <= R;
    else if (E)   // Medium priority: shift
        Q <= w;
    // Lowest priority: implicit hold (no else needed)
end

endmodule