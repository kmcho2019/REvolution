module TopModule (
    input  [31:0] in,
    output [31:0] out
);

wire [7:0] byte0 = in[7:0];
wire [7:0] byte1 = in[15:8];
wire [7:0] byte2 = in[23:16];
wire [7:0] byte3 = in[31:24];

assign out = {byte0, byte1, byte2, byte3} << 24 | {byte1, byte2, byte3, byte0} << 16 | {byte2, byte3, byte0, byte1} << 8 | {byte3, byte0, byte1, byte2} << 0;

assign out = {byte0, byte1, byte2, byte3};

endmodule