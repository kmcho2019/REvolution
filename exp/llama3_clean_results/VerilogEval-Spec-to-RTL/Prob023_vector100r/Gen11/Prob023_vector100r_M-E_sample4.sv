module TopModule(
    input  [99:0] in,
    output [99:0] out
);

    // Dividing the 100-bit vector into four segments of 25 bits each
    wire [24:0] seg0 = in[99:75];
    wire [24:0] seg1 = in[74:50];
    wire [24:0] seg2 = in[49:25];
    wire [24:0] seg3 = in[24:0];

    // Reversing each segment
    wire [24:0] rev_seg0;
    wire [24:0] rev_seg1;
    wire [24:0] rev_seg2;
    wire [24:0] rev_seg3;

    // Using a generate block for a concise and scalable implementation within each segment
    genvar i;
    generate
        for (i = 0; i < 25; i++) begin
            assign rev_seg0[i] = seg0[24 - i];
            assign rev_seg1[i] = seg1[24 - i];
            assign rev_seg2[i] = seg2[24 - i];
            assign rev_seg3[i] = seg3[24 - i];
        end
    endgenerate

    // Combining the reversed segments to form the final output
    assign out[99:75] = rev_seg3;
    assign out[74:50] = rev_seg2;
    assign out[49:25] = rev_seg1;
    assign out[24:0] = rev_seg0;

endmodule