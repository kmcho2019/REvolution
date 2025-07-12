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

// Buffer the reset signal to minimize fanout
wire reset_buf;
assign reset_buf = areset;

// Clock gating control (simplified example)
wire clk_enable = |(d ^ q); // Enable clock when input differs from output
wire gated_clk = clk & clk_enable;

// Generate 8 DFFs using a loop
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : dff_gen
        DFF dff_inst (
            .clk(gated_clk),
            .areset(reset_buf),
            .d(d[i]),
            .q(q[i])
        );
    end
endgenerate

endmodule