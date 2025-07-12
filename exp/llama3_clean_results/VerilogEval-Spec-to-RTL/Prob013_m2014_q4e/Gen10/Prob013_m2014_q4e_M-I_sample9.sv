module TopModule(
    input  in1,
    input  in2,
    output out
);
    // The existing implementation is already optimized.
    // However, ensuring the synthesis tool optimizes for area and power might further improve PPA metrics.
    assign out = ~(in1 | in2);
endmodule