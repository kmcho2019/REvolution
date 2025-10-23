module TopModule (
    input  [99:0] in,
    output [99:0] out
);

// Macro-reversal: Reverse the order of 5 segments (20 bits each)
wire [19:0] seg_rev[4:0];
assign seg_rev[0] = in[99:80];
assign seg_rev[1] = in[79:60];
assign seg_rev[2] = in[59:40];
assign seg_rev[3] = in[39:20];
assign seg_rev[4] = in[19:0];

// Micro-reversal: Reverse bits within each segment
genvar i, j;
generate
    for (i = 0; i < 5; i = i + 1) begin : segment_reversal
        for (j = 0; j < 20; j = j + 1) begin : bit_reversal
            assign out[(4-i)*20 + j] = seg_rev[i][19-j];
        end
    end
endgenerate

endmodule