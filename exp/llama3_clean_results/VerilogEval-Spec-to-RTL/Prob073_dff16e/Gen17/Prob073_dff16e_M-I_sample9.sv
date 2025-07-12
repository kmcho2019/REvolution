module ByteRegister(
    input clk,
    input resetn,
    input ena,
    input [7:0] d,
    output reg [7:0] q
);

always @(posedge clk) begin
    q <= (resetn) ? (ena ? d : q) : 8'd0;
end

endmodule

module TopModule(
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output reg [15:0] q
);

ByteRegister lowerByteReg(
   .clk(clk),
   .resetn(resetn),
   .ena(byteena[0]),
   .d(d[7:0]),
   .q(q[7:0])
);

ByteRegister upperByteReg(
   .clk(clk),
   .resetn(resetn),
   .ena(byteena[1]),
   .d(d[15:8]),
   .q(q[15:8])
);

endmodule