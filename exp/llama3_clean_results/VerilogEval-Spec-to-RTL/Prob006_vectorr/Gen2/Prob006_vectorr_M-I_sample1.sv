module TopModule(
    input  [7:0] in,
    output [7:0] out
);

// The existing code already achieves the desired functionality in a straightforward manner.
// The code is kept as is because any changes could potentially introduce unnecessary complexity or negatively affect synthesis.
assign out = {in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7]};

endmodule