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
        Q <= R;  // Parallel load
    end
    else if (E) begin
        Q <= w;  // Shift operation
    end
    // Else maintain current state (implicit)
end

endmodule