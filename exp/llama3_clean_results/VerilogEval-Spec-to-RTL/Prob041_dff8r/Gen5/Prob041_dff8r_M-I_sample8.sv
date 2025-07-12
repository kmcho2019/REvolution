module DFF(
    input clk,
    input reset,
    input d,
    output logic q
);

always_ff @(posedge clk) begin
    if (reset) begin
        q <= 1'b0;
    end else begin
        q <= d;
    end
end

endmodule

module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output logic [7:0] q
);

logic clk_gated;
assign clk_gated = clk & ~reset;

genvar i;
generate
    for (i = 0; i < 8; i++) begin
        DFF dff_i(
            .clk(clk_gated),
            .reset(reset),
            .d(d[i]),
            .q(q[i])
        );
    end
endgenerate

endmodule