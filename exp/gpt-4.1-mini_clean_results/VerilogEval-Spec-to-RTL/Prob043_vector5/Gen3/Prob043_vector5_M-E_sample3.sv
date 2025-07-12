module TopModule (
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    input  wire e,
    output wire [24:0] out
);

    // Define a 5x5 array to hold pairwise equality bits
    wire [4:0] row0; // comparisons for 'a' with a,b,c,d,e
    wire [4:0] row1; // comparisons for 'b' with a,b,c,d,e
    wire [4:0] row2; // comparisons for 'c' with a,b,c,d,e
    wire [4:0] row3; // comparisons for 'd' with a,b,c,d,e
    wire [4:0] row4; // comparisons for 'e' with a,b,c,d,e

    // Compute each row explicitly using XNOR (~^) for equality
    assign row0 = {a ~^ a, a ~^ b, a ~^ c, a ~^ d, a ~^ e}; // MSBs
    assign row1 = {b ~^ a, b ~^ b, b ~^ c, b ~^ d, b ~^ e};
    assign row2 = {c ~^ a, c ~^ b, c ~^ c, c ~^ d, c ~^ e};
    assign row3 = {d ~^ a, d ~^ b, d ~^ c, d ~^ d, d ~^ e};
    assign row4 = {e ~^ a, e ~^ b, e ~^ c, e ~^ d, e ~^ e}; // LSBs

    // Concatenate rows from top-left pair (a,a) as MSB to bottom-right (e,e) as LSB
    assign out = {row0, row1, row2, row3, row4};

endmodule