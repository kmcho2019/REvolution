module TopModule (
    input  wire [31:0] in,  // 32-bit input vector
    output wire [31:0] out  // 32-bit output vector with bytes reversed
);

    // Use concatenation and part-select operations to reverse the byte order
    assign out = {in[23:0], in[31:24]};

    // Break down the assignment into separate lines for clarity
    // assign out[ 7:0] = in[23:16];
    // assign out[15:8] = in[15:8];
    // assign out[23:16] = in[ 7:0];
    // assign out[31:24] = in[31:24];

    // Final implementation using single assign statement
    assign out = {in[ 7:0], in[15:8], in[23:16], in[31:24]};

endmodule