module TopModule(
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

// Generate a gated clock to reduce power consumption
wire gated_clk;
assign gated_clk = (L || E) ? clk : 1'b0;

always @(posedge gated_clk) begin
    if (L) begin
        Q <= R;
    end else if (E) begin
        Q <= w;
    end
end

endmodule