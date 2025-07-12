module TopModule(
    input  [15:0] in,
    output [7:0] out_hi,
    output [7:0] out_lo
);

    // Divide the 16-bit input into four 4-bit segments
    wire [3:0] segment0 = in[3:0];
    wire [3:0] segment1 = in[7:4];
    wire [3:0] segment2 = in[11:8];
    wire [3:0] segment3 = in[15:12];

    // Form the upper byte by concatenating and shifting the appropriate segments
    assign out_hi = {segment3, segment2};

    // Form the lower byte by concatenating and shifting the appropriate segments
    assign out_lo = {segment1, segment0};

endmodule