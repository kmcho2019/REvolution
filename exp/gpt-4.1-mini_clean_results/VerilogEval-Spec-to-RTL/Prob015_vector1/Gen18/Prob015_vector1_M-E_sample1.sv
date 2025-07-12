module TopModule (
    input  [15:0] in,
    output [7:0]  out_hi,
    output [7:0]  out_lo
);
    // Extract low byte by masking lower 8 bits
    assign out_lo = in & 16'h00FF;
    
    // Extract high byte by shifting right 8 bits and masking lower 8 bits
    assign out_hi = (in >> 8) & 8'hFF;
endmodule