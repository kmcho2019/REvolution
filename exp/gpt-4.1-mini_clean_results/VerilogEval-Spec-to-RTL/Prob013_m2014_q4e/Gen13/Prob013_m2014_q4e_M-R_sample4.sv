module TopModule (
    input  in1,
    input  in2,
    output out
);
    // Directly assign the NOR function without intermediate module instantiation
    assign out = ~(in1 | in2);
endmodule