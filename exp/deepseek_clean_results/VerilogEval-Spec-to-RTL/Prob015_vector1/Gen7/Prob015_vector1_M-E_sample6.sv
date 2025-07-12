module TopModule (
    input  [15:0] in,
    output [7:0] out_hi,
    output [7:0] out_lo
);

    localparam BYTE_WIDTH = 8;
    localparam MASK = {BYTE_WIDTH{1'b1}};  // Creates 8'b11111111
    
    // Extract upper byte by shifting right
    assign out_hi = in >> BYTE_WIDTH;
    
    // Extract lower byte by masking
    assign out_lo = in & MASK;

endmodule