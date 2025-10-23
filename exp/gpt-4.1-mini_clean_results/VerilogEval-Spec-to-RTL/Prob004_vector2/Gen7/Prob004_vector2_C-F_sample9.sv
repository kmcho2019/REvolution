module TopModule (
    input  [31:0] in,
    output [31:0] out
);

    // Define bytes as localparams for clarity and potential synthesis optimization
    localparam [7:0] byte0 = in[31:24];
    localparam [7:0] byte1 = in[23:16];
    localparam [7:0] byte2 = in[15:8];
    localparam [7:0] byte3 = in[7:0];

    // Concatenate bytes in reverse order
    assign out = {byte3, byte2, byte1, byte0};

endmodule