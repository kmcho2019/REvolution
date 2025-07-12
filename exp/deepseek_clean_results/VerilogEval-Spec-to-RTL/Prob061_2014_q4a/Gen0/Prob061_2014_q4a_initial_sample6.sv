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
        Q <= w;   // Shift operation
    end
    // No else: Q maintains its value when neither L nor E is asserted
end

endmodule