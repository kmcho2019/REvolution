module TopModule(
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

reg clock_enable;

always @(posedge clk) begin
    clock_enable <= (E || L);
end

always @(posedge clk) begin
    if (clock_enable) begin
        if (L) begin
            Q <= R;
        end else if (E) begin
            Q <= w;
        end
    end
end

endmodule