module DFF (
    input clk,
    input areset,
    input d,
    output reg q
);

always @(posedge clk or posedge areset) begin
    if (areset) begin
        q <= 1'b0;
    end
    else begin
        q <= d;
    end
end

endmodule

module TopModule (
    input clk,
    input areset,
    input [7:0] d,
    output [7:0] q
);

// Local reset buffer to minimize fanout
wire local_areset;
buf reset_buf (local_areset, areset);

// Clock gating control (simplified version)
wire clk_enable = |(d ^ q);  // Enable clock when input differs from output

// Gated clock
wire gated_clk;
and clk_gate (gated_clk, clk, clk_enable);

// Generate 8 DFFs using loop
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : dff_gen
        DFF dff_inst (
            .clk(gated_clk),
            .areset(local_areset),
            .d(d[i]),
            .q(q[i])
        );
    end
endgenerate

endmodule