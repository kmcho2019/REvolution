module TopModule (
    input  in1,
    input  in2,
    input  in3,
    output out
);
    // Direct combinational expression for output
    assign out = (~(in1 ^ in2)) ^ in3;
endmodule