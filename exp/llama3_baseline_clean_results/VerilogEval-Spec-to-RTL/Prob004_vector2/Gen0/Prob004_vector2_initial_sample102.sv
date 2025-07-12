module TopModule(
    input  [31:0] in,  // 32-bit input
    output [31:0] out   // 32-bit output
);

    // Split the input into four bytes and assign them to the output in reverse order
    assign out = {in[7:0], in[15:8], in[23:16], in[31:24]};

endmodule