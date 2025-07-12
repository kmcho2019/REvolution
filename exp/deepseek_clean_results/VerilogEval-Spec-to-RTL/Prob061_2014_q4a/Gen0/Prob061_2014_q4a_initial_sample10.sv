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
        Q <= R;  // Parallel load takes priority
    end
    else if (E) begin
        Q <= w;  // Shift operation when enabled
    end
    // If neither L nor E is high, Q maintains its value
end

endmodule