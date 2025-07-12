module TopModule (
    input in1,
    input in2,
    output out
);
    // MUX-based implementation of in1 AND (NOT in2)
    assign out = in2 ? 1'b0 : in1;
endmodule