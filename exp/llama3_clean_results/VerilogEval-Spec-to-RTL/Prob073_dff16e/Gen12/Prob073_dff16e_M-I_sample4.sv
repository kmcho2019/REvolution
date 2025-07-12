module ByteModule(
    input clk,
    input resetn,
    input byteena,
    input [7:0] d,
    output reg [7:0] q
);

always @(posedge clk) begin
    if (!resetn) begin
        q <= 8'd0;
    end else if (byteena) begin
        q <= d;
    end else begin
        // Adding an else clause to explicitly keep the output unchanged
        // when byteena is 0, to minimize switching activity.
        q <= q;
    end
end

endmodule

module TopModule(
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output reg [15:0] q
);

ByteModule upper_byte(
  .clk(clk),
  .resetn(resetn),
  .byteena(byteena[1]),
  .d(d[15:8]),
  .q(q[15:8])
);

ByteModule lower_byte(
  .clk(clk),
  .resetn(resetn),
  .byteena(byteena[0]),
  .d(d[7:0]),
  .q(q[7:0])
);

endmodule