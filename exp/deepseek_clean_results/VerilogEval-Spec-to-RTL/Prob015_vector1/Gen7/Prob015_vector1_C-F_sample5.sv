module TopModule (
    input  [15:0] in,
    output [7:0]  out_hi,
    output [7:0]  out_lo
);

    // Parameterized bit ranges for maintainability
    localparam UPPER_BYTE_MSB = 15;
    localparam UPPER_BYTE_LSB = 8;
    localparam LOWER_BYTE_MSB = 7;
    localparam LOWER_BYTE_LSB = 0;

    // Optimal implementation - direct bit selection
    assign out_hi = in[UPPER_BYTE_MSB:UPPER_BYTE_LSB];  // Equivalent to: (in >> 8)
    assign out_lo = in[LOWER_BYTE_MSB:LOWER_BYTE_LSB];   // Equivalent to: (in & 8'hFF)

    /* Alternative conceptual implementations (synthesize to same result):
    // Shift-register style
    assign out_hi = in >> 8;
    
    // Masking style
    assign out_lo = in & 8'hFF;
    */

endmodule