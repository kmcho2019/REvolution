module TopModule (
    input  [15:0] in,          // 16-bit input word
    output [7:0]  out_hi,       // Upper byte [15:8]
    output [7:0]  out_lo        // Lower byte [7:0]
);

    // Parameters for clear bit-width definition
    localparam INPUT_WIDTH = 16;
    localparam BYTE_WIDTH  = 8;

    // Direct bit-slicing assignments (optimal PPA)
    assign out_hi = in[INPUT_WIDTH-1:BYTE_WIDTH];
    assign out_lo = in[BYTE_WIDTH-1:0];

endmodule