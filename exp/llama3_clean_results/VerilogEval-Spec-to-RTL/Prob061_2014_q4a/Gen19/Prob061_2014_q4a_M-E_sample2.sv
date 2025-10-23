module TopModule(
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

reg mux_out;

always @(*) begin
    if (L) begin
        // Load R into mux_out
        mux_out = R;
    end else if (E) begin
        // Shift w into mux_out
        mux_out = w;
    end else begin
        // Hold the current value
        mux_out = Q;
    end
end

always @(posedge clk) begin
    Q <= mux_out;
end

endmodule