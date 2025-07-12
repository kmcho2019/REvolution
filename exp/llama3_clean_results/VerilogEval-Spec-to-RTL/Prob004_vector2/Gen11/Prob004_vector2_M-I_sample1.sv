module TopModule (
    input  wire [31:0] in,  // 32-bit input vector
    output wire [31:0] out  // 32-bit output vector with bytes reversed
);

    // Utilize the same direct assignment strategy but consider any synthesis directives
    // that might help in optimizing area without affecting performance or power
    assign out = {in[7:0], in[15:8], in[23:16], in[31:24]};  // Reverse byte order

endmodule