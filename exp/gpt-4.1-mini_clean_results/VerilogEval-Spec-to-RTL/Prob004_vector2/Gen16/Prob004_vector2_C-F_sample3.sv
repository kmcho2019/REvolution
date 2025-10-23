module TopModule (
    input  [31:0] in,
    output reg [31:0] out
);

always @(*) begin
    // Extract bytes for clarity
    wire [7:0] byte0 = in[7:0];
    wire [7:0] byte1 = in[15:8];
    wire [7:0] byte2 = in[23:16];
    wire [7:0] byte3 = in[31:24];

    // Assign reversed bytes to output
    out[31:24] = byte0;
    out[23:16] = byte1;
    out[15:8]  = byte2;
    out[7:0]   = byte3;
end

endmodule