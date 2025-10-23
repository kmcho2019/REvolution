module TopModule (
    input  wire a,
    input  wire b,
    output wire q
);
    // Directly instantiate a single AND primitive gate for minimal delay, power, and area
    and (q, a, b);
endmodule