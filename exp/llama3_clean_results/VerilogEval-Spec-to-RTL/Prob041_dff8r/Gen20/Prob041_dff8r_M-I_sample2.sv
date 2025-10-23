module DFF #(
    parameter WIDTH = 8
)(
    input clk,
    input reset,
    input [WIDTH-1:0] d,
    output logic [WIDTH-1:0] q
);

always_ff @(posedge clk) begin
    if (reset) q <= '0; 
    else q <= d;
end

endmodule

module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output logic [7:0] q
);

logic clk_gated;

// Clock gating to reduce dynamic power consumption
always_ff @(posedge clk) begin
    if (reset) clk_gated <= 1'b0;
    else if (d != 8'b0) clk_gated <= 1'b1;
    else clk_gated <= 1'b0;
end

DFF #(.WIDTH(8)) dff(
    .clk(clk_gated ? clk : 1'b0), // Apply clock gating
    .reset(reset),
    .d(d),
    .q(q)
);

endmodule