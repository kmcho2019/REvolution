module ByteModule(
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output reg [15:0] q
);

always @(posedge clk) begin
    q <= (!resetn) ? 16'd0 : 
         (byteena[1]) ? {d[15:8], q[7:0]} :
         (byteena[0]) ? {q[15:8], d[7:0]} : 
         q;
end

endmodule

module TopModule(
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output reg [15:0] q
);

ByteModule byte_module(
   .clk(clk),
   .resetn(resetn),
   .byteena(byteena),
   .d(d),
   .q(q)
);

endmodule