module TopModule(
    input  [7:0] in,
    output [7:0] out
);
    
    assign out = {in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7]};
    // Alternatively, you could also write the following to reverse the bits
    // assign out = in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7];
    // However, the best way to reverse the bits in Verilog is:
    assign out = in[7:0];

endmodule