module TopModule (
    input  [15:0] in,
    output [7:0]  out_hi,
    output [7:0]  out_lo
);

    // Extract high byte by shifting right then masking
    assign out_hi = (in >> 8) & 8'hFF;
    
    // Extract low byte by direct masking
    assign out_lo = in & 8'hFF;

endmodule