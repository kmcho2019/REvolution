module TopModule (
    input  [99:0] in,
    output [99:0] out
);

assign out = {in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7], in[8], in[9],
              in[10], in[11], in[12], in[13], in[14], in[15], in[16], in[17], in[18], in[19],
              in[20], in[21], in[22], in[23], in[24], in[25], in[26], in[27], in[28], in[29],
              in[30], in[31], in[32], in[33], in[34], in[35], in[36], in[37], in[38], in[39],
              in[40], in[41], in[42], in[43], in[44], in[45], in[46], in[47], in[48], in[49],
              in[50], in[51], in[52], in[53], in[54], in[55], in[56], in[57], in[58], in[59],
              in[60], in[61], in[62], in[63], in[64], in[65], in[66], in[67], in[68], in[69],
              in[70], in[71], in[72], in[73], in[74], in[75], in[76], in[77], in[78], in[79],
              in[80], in[81], in[82], in[83], in[84], in[85], in[86], in[87], in[88], in[89],
              in[90], in[91], in[92], in[93], in[94], in[95], in[96], in[97], in[98], in[99]};

// However, this isn't very elegant for 100 bits, so let's improve this
// and do it programmatically instead.

// Using a generate block we can programmatically create the connections
// between the input and output bits.

// An alternative way of writing this is using a for loop in a generate block
// to produce the assignment.

// Alternatively we can also use the following always block with a for loop
// to achieve the same.

// Or a simple continuous assignment with a bit reversing function

// Here's the simplest and most elegant way of implementing this.

genvar i;
generate
    for (i = 0; i < 100; i++) begin
        assign out[i] = in[99 - i];
    end
endgenerate

endmodule