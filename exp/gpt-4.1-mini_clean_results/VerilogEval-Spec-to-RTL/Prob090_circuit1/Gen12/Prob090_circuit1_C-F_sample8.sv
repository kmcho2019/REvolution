module TopModule (
    input  wire a,
    input  wire b,
    output wire q
);
    // Structural instantiation of a single AND gate primitive
    and u_and (q, a, b);
endmodule