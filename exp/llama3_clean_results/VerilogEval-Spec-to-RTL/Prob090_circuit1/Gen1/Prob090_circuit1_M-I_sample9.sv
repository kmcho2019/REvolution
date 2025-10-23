module TopModule(
    input a,
    input b,
    output q
);

// Using the most efficient AND operation available
assign q = a && b;

endmodule