module TopModule (
    input  [15:0] in,
    output [7:0] out_hi,
    output [7:0] out_lo
);

    wire [15:0] shifted_in;
    
    // Get upper byte by right shifting by 8 bits
    assign shifted_in = in >> 8;
    assign out_hi = shifted_in[7:0];
    
    // Get lower byte by masking with 8'hFF
    assign out_lo = in & 8'hFF;

endmodule