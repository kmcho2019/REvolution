module TopModule(
    input  [99:0] in,  // 100-bit input
    output [99:0] out // 100-bit output
);

// Continuous assignment to reverse the bit ordering
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

// However, to make this a scalable solution for any bit width, consider using a for loop
// in an always or initial block, or a more compact assignment method.
// Alternatively, the following concise version can be used for any bit width:
// assign out = in[99:0]; does not reverse, so we use {in[99], in[98], ... , in[0]}
// For such a specific width, it's easy, but for generalizing the solution:
// assign out = { >> {in[99:0]} }; // does not work as intended
// The following would work, though it is not allowed in Verilog for continuous assignment:
// for (int i = 0; i < 100; i++) out[i] = in[99 - i];
// The simplest form that is synthesizable and reversible would look like this:

endmodule

// Thus a simplification of the above would look like this:
module TopModule (
    input  [99:0] in,
    output [99:0] out
);
    assign out = in[99:0]; // doesn't reverse, so instead:
    assign out = {in[99], in[98], in[97], in[96], in[95], in[94], in[93], in[92], in[91], in[90],
                  in[89], in[88], in[87], in[86], in[85], in[84], in[83], in[82], in[81], in[80],
                  in[79], in[78], in[77], in[76], in[75], in[74], in[73], in[72], in[71], in[70],
                  in[69], in[68], in[67], in[66], in[65], in[64], in[63], in[62], in[61], in[60],
                  in[59], in[58], in[57], in[56], in[55], in[54], in[53], in[52], in[51], in[50],
                  in[49], in[48], in[47], in[46], in[45], in[44], in[43], in[42], in[41], in[40],
                  in[39], in[38], in[37], in[36], in[35], in[34], in[33], in[32], in[31], in[30],
                  in[29], in[28], in[27], in[26], in[25], in[24], in[23], in[22], in[21], in[20],
                  in[19], in[18], in[17], in[16], in[15], in[14], in[13], in[12], in[11], in[10],
                  in[9],  in[8],  in[7],  in[6],  in[5],  in[4],  in[3],  in[2],  in[1],  in[0]};
// That is basically what you would need for a direct 1:1 assignment.

// Generalization for n bits using a for loop (not synthesizable in this form, just an idea):
// for (int i = 0; i < n; i++) begin
//     out[i] = in[n-1-i];
// end
// So we go with the assignment.
// A better approach would look like this, though we cannot synthesize a loop:
// always @(*) begin
//     for (int i = 0; i < 100; i++) begin
//         out[i] = in[99-i];
//     end
// end
// But here is how you actually implement it in a synthesizable way using a for-generate loop: