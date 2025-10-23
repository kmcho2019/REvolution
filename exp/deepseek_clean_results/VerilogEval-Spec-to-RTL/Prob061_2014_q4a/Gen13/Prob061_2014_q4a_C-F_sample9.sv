module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

// Priority logic: Load (L) has higher priority than Shift (E)
wire next_Q = L ? R : (E ? w : Q);

// Sequential element updates on clock edge
always @(posedge clk) begin
    Q <= next_Q;
end

endmodule