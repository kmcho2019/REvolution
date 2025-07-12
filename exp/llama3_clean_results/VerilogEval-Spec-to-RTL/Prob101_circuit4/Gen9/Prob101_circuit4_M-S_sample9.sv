module TopModule(
    input a,
    input b,
    input c,
    input d, // This input does not affect the output based on the provided simulation
    output q
);

assign q = b || c || (a && (b || c));

endmodule