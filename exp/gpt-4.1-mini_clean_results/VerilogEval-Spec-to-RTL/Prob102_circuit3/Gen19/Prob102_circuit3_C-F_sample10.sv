module TopModule (
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    output wire q
);
    wire x = a | b;
    wire y = c | d;
    assign q = x & y;
endmodule