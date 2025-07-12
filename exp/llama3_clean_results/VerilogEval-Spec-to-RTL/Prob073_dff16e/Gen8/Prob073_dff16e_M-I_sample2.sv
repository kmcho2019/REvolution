module ByteRegister(
    input         clk,
    input         resetn,
    input         byteena,
    input  [7:0]  d,
    output [7:0]  q
);

reg [7:0] q_reg;

always @(posedge clk) begin
    if (~resetn) begin
        q_reg <= 8'd0;
    end else if (byteena) begin
        q_reg <= d;
    end
end

assign q = q_reg;

endmodule

module TopModule(
    input         clk,
    input         resetn,
    input  [1:0]  byteena,
    input  [15:0] d,
    output [15:0] q
);

wire clk_upper_byte = clk & byteena[1];
wire clk_lower_byte = clk & byteena[0];

ByteRegister u_upper_byte(
   .clk(clk_upper_byte),
   .resetn(resetn),
   .byteena(1'b1), // Always enabled when clock is gated
   .d(d[15:8]),
   .q(q[15:8])
);

ByteRegister u_lower_byte(
   .clk(clk_lower_byte),
   .resetn(resetn),
   .byteena(1'b1), // Always enabled when clock is gated
   .d(d[7:0]),
   .q(q[7:0])
);

endmodule