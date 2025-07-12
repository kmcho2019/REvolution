module TopModule (
    input  a,
    input  b,
    output sum,
    output cout
);

// sum as continuous assign for clarity and synthesis optimization
assign sum = a ^ b;

// cout as explicit gate primitive for direct structural mapping
and (cout, a, b);

endmodule