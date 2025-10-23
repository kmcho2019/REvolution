module ByteRegister(
    input         clk,
    input         resetn,
    input         byteena,
    input  [7:0]  d,
    output [7:0]  q
);

reg [7:0] q_reg;
reg         clk_gated;

always @(posedge clk) begin
    if (~resetn) begin
        q_reg <= 8'd0;
    end else if (byteena) begin
        q_reg <= d;
    end
end

assign q = q_reg;

// Clock gating
assign clk_gated = clk & byteena;

// Use the gated clock for the DFFs
// Note: In Verilog, the always block is sensitive to posedge clk.
//       To use the gated clock, we must ensure it is synchronized with the original clock.
always @(posedge clk_gated or negedge resetn) begin
    if (~resetn) begin
        q_reg <= 8'd0;
    end else begin
        q_reg <= d;
    end
end

endmodule

module TopModule(
    input         clk,
    input         resetn,
    input  [1:0]  byteena,
    input  [15:0] d,
    output [15:0] q
);

ByteRegister u_upper_byte(
    .clk(clk),
    .resetn(resetn),
    .byteena(byteena[1]),
    .d(d[15:8]),
    .q(q[15:8])
);

ByteRegister u_lower_byte(
    .clk(clk),
    .resetn(resetn),
    .byteena(byteena[0]),
    .d(d[7:0]),
    .q(q[7:0])
);

endmodule