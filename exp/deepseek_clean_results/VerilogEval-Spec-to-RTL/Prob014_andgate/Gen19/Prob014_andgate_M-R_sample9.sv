module TopModule (
    input  wire a,
    input  wire b,
    output wire out
);
    // Using continuous assignment with logical AND
    assign out = a & b;
endmodule