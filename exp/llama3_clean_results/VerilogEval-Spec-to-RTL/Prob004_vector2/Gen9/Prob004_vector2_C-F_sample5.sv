module TopModule (
    input  wire [31:0] in,  // 32-bit input vector
    output reg [31:0] out  // 32-bit output vector with bytes reversed
);

    // Directly assign the bytes of the input vector to the output vector in reverse order
    always @(*) begin
        out = {in[7:0], in[15:8], in[23:16], in[31:24]};  // Reverse byte order
    end

endmodule