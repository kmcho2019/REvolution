module TopModule(
    input  [31:0] in,
    output [31:0] out
);

// Divide the input into 4 bytes
wire [7:0] byte0 = in[7:0];
wire [7:0] byte1 = in[15:8];
wire [7:0] byte2 = in[23:16];
wire [7:0] byte3 = in[31:24];

// Reverse the byte order
assign out = {byte3, byte2, byte1, byte0};

endmodule