module TopModule (
    input  wire [31:0] in,  // 32-bit input vector
    output reg [31:0] out  // 32-bit output vector with bytes reversed
);

    always @(*) begin
        out[7:0]   = in[31:24];  // Assign most significant byte to least significant byte
        out[15:8]  = in[23:16];  // Assign second most significant byte to second least significant byte
        out[23:16] = in[15:8];   // Assign middle byte to middle byte
        out[31:24] = in[7:0];    // Assign least significant byte to most significant byte
    end

endmodule