module TopModule (
    input  wire a,
    input  wire b,
    output wire q
);
    // Direct implementation of AND using primitive gate for best PPA
    and (q, a, b);
endmodule