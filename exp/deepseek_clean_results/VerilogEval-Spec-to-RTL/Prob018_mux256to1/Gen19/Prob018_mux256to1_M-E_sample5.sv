module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    // Segment the input into 8 chunks of 32 bits
    wire [31:0] segments [7:0];
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : SEGMENT
            assign segments[i] = in[(i*32)+31 : i*32];
        end
    endgenerate

    // Use upper 3 bits to select active segment
    wire [31:0] active_segment;
    assign active_segment = segments[sel[7:5]];

    // Barrel shift within the segment using lower 5 bits
    wire [31:0] shifted_segment;
    assign shifted_segment = active_segment >> sel[4:0];

    // Output is LSB of shifted segment
    assign out = shifted_segment[0];

endmodule