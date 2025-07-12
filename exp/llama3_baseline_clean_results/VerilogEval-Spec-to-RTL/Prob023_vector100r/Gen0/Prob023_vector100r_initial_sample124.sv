module TopModule(
    input  [99:0] in,
    output [99:0] out
);

assign out = in[99:0];

// A more explicit way to reverse the bits
// assign out = {in[99], in[98], in[97], ..., in[1], in[0]};
// But the above assign is more efficient and concise.

// Another approach would be using a for loop in a generate block
// But for a simple assignment like this, the first approach is preferred.

endmodule