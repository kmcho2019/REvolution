module TopModule (
    input in1,
    input in2,
    output out
);
    // MUX implementation of AND with inverted in2
    assign out = in2 ? 1'b0 : in1;
endmodule