module TopModule(
    input  [31:0] in,
    output [31:0] out
);

// Declare wires for each byte of the input vector
wire [7:0] byte0;
wire [7:0] byte1;
wire [7:0] byte2;
wire [7:0] byte3;

// Assign each byte of the input vector to the corresponding wire
assign byte0 = in[7:0];
assign byte1 = in[15:8];
assign byte2 = in[23:16];
assign byte3 = in[31:24];

// Concatenate the bytes in reverse order to form the output vector
assign out = {byte3, byte2, byte1, byte0};

endmodule