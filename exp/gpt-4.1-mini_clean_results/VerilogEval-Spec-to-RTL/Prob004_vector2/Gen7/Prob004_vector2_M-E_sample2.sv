module TopModule (
    input  [31:0] in,
    output [31:0] out
);

wire [7:0] byte0 = (in >> 0)  & 8'hFF;
wire [7:0] byte1 = (in >> 8)  & 8'hFF;
wire [7:0] byte2 = (in >> 16) & 8'hFF;
wire [7:0] byte3 = (in >> 24) & 8'hFF;

assign out = (byte0 << 24) | (byte1 << 16) | (byte2 << 8) | (byte3 << 0);

endmodule