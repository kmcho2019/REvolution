module TopModule(
    input  in1,
    input  in2,
    output out
);
    // Maintaining the simplicity of the design while ensuring synthesis tool optimization.
    // The existing implementation is already optimized for area and power.
    assign out = ~(in1 | in2);
endmodule