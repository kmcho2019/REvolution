module TopModule (
    input wire a,
    input wire b,
    input wire c,
    input wire d,
    output wire q
);
    or (q, b, c); // direct built-in OR gate primitive for minimal logic
endmodule