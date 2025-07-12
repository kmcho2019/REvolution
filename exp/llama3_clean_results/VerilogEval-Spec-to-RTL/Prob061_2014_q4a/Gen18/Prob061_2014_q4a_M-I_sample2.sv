module TopModule(
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

always @(posedge clk) begin
    if (L) begin
        // Load R into Q
        Q <= R;
    end else if (E) begin
        // Shift w into Q
        Q <= w;
    end
end

endmodule