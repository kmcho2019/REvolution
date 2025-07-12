module TopModule(
    input  [15:0] in,
    output [7:0] out_hi,
    output [7:0] out_lo
);

    // Shift input 8 bits to the right and assign lower 8 bits to out_hi
    assign out_hi = in >> 8;
    
    // Directly assign lower 8 bits of input to out_lo
    assign out_lo = in[7:0];

endmodule