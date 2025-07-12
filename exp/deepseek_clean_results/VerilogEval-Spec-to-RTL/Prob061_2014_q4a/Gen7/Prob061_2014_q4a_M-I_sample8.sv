module TopModule (
    input clk, w, R, E, L,
    output reg Q
);

wire enable = L || E;
wire next_Q = L ? R : w;

always @(posedge clk if enable) begin
    if (enable) begin
        Q <= next_Q;
    end
    // else retain value (clock gated)
end

endmodule