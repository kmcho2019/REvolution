module TopModule (
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output [3:0] q
);

    // Concatenate inputs as vector of 4 elements: index 0 = b, 1 = e, 2 = a, 3 = d
    wire [15:0] vector = {d, a, e, b};
    wire c_lt4 = (c < 4);

    // Select one 4-bit slice based on c[1:0]
    wire [3:0] selected = vector >> (c[1:0]*4);

    // Assign q: if c < 4 output selected, else 4'hF
    assign q = c_lt4 ? selected : 4'hF;

endmodule