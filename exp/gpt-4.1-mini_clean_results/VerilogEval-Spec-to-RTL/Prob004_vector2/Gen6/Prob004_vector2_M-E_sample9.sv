module TopModule (
    input  [31:0] in,
    output reg [31:0] out
);

always @(*) begin
    // Extract each byte
    case (1'b1)
        default: begin
            out[31:24] = in[7:0];     // Byte 0 to Byte 3 position
            out[23:16] = in[15:8];    // Byte 1 to Byte 2 position
            out[15:8]  = in[23:16];   // Byte 2 to Byte 1 position
            out[7:0]   = in[31:24];   // Byte 3 to Byte 0 position
        end
    endcase
end

endmodule