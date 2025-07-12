module TopModule(
    input  [15:0] in,  // 16-bit input
    output [7:0] out_hi,  // Upper 8 bits of input
    output [7:0] out_lo   // Lower 8 bits of input
);
    // Directly assign the upper 8 bits of the input to out_hi
    assign out_hi = in[15:8];  
    // Directly assign the lower 8 bits of the input to out_lo
    assign out_lo = in[7:0];   
endmodule