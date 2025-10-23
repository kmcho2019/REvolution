module TopModule (
    input  wire x3,
    input  wire x2,
    input  wire x1,
    output wire f
);

    // Combinational logic implementing:
    // f = (x3) ? x1 : x2;
    // This is a simple 2:1 multiplexer with select input x3,
    // choosing between x1 and x2 as output f.
    assign f = x3 ? x1 : x2;

endmodule