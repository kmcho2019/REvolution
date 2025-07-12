module TopModule (
    input  [99:0] in,
    output [99:0] out
);

    // Divide the input into 4 segments of 25 bits each
    wire [24:0] seg1 = in[24:0];
    wire [24:0] seg2 = in[49:25];
    wire [24:0] seg3 = in[74:50];
    wire [24:0] seg4 = in[99:75];

    // Use multiplexers to rearrange the bits
    assign out[99:75] = seg4;
    assign out[74:50] = seg3;
    assign out[49:25] = seg2;
    assign out[24:0]  = seg1;

endmodule