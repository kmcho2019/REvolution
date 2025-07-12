module TopModule(
    input  in1,
    input  in2,
    output out
);
    // The design is already optimized for PPA metrics, and given its simplicity, 
    // further optimization is unlikely to yield significant improvements.
    assign out = ~(in1 | in2);
endmodule