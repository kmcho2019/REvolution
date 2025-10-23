module TopModule (
    input [4:0] a,
    input [4:0] b,
    input [4:0] c,
    input [4:0] d,
    input [4:0] e,
    input [4:0] f,
    output [7:0] w,
    output [7:0] x,
    output [7:0] y,
    output [7:0] z
);

    // Directly assign outputs from concatenated inputs
    assign w = {a, b[4:2]};
    assign x = {b[1:0], c, d[4:3]};
    assign y = {d[2:0], e, f[4:1]};
    assign z = {f[0], 2'b11, 5'b0}; // Explicitly show the two '1' bits and pad with zeros

endmodule