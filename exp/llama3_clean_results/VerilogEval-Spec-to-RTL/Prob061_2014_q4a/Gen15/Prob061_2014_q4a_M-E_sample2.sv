module TopModule(
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

wire mux_out;
assign mux_out = L ? R : w;

always @(posedge clk) begin
    if (E || L) begin
        Q <= mux_out;
    end
end

endmodule