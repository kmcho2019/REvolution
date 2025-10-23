module TopModule(
    input a,
    input b,
    input c, // This input is not used but included to match the interface requirement
    output out
);

assign out = a | b;

endmodule