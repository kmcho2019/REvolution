module ByteRegister(
    input         clk,
    input         resetn,
    input         byteena,
    input  [7:0]  d,
    output reg [7:0] q
);

always @(posedge clk) begin
    q <= (!resetn) ? 8'd0 : (byteena) ? d : q;
end

endmodule

module TopModule(
    input         clk,
    input         resetn,
    input  [1:0]  byteena,
    input  [15:0] d,
    output reg [15:0] q
);

ByteRegister upper_byte(
   .clk(clk),
   .resetn(resetn),
   .byteena(byteena[1]),
   .d(d[15:8]),
   .q(q[15:8])
);

ByteRegister lower_byte(
   .clk(clk),
   .resetn(resetn),
   .byteena(byteena[0]),
   .d(d[7:0]),
   .q(q[7:0])
);

endmodule