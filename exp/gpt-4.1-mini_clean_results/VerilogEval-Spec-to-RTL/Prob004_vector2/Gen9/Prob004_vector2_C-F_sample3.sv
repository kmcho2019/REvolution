module TopModule (
    input  [31:0] in,
    output [31:0] out
);

    // Define byte slices as localparams for clarity without extra hardware
    localparam [7:0] byte0 = 8'd0; // dummy placeholder to avoid synthesis warnings
    localparam [7:0] byte1 = 8'd0;
    localparam [7:0] byte2 = 8'd0;
    localparam [7:0] byte3 = 8'd0;

    // Assign the byte slices directly from input
    wire [7:0] b0 = in[31:24];
    wire [7:0] b1 = in[23:16];
    wire [7:0] b2 = in[15:8];
    wire [7:0] b3 = in[7:0];

    assign out = {b3, b2, b1, b0};

endmodule