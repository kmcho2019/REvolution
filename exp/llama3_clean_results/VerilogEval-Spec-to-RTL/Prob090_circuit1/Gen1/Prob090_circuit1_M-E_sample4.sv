module TopModule(
    input a,
    input b,
    output q
);

assign q = a? b : 0;

endmodule