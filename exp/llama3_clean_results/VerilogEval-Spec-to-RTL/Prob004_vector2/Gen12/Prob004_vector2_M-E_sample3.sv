module TopModule (
    input  wire [31:0] in,  // 32-bit input vector
    output reg [31:0] out  // 32-bit output vector with bytes reversed
);

    always @(*) begin
        // Split the input into individual bytes
        reg [7:0] byte0 = in[7:0];
        reg [7:0] byte1 = in[15:8];
        reg [7:0] byte2 = in[23:16];
        reg [7:0] byte3 = in[31:24];

        // Reverse the byte order
        out = {byte3, byte2, byte1, byte0};
    end

endmodule