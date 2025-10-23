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
        Q <= R;  // Highest priority: load
    end
    else if (E) begin
        Q <= w;  // Next priority: shift
    end
    // Else: maintain current value (implied by not assigning)
end

endmodule