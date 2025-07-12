module TopModule (
    input  wire a,
    input  wire b,
    output wire q
);
    // Direct behavioral assignment with built-in AND operator for optimal PPA
    assign q = a & b;
endmodule