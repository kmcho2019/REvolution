module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

// State tracking
reg mode; // 0 = hold, 1 = shift/load

always @(posedge clk) begin
    // Mode selection (evaluated first)
    mode <= (L || E);
end

always @(posedge clk) begin
    // Data path (evaluated second)
    if (mode) begin
        Q <= L ? R : w;
    end
end

endmodule