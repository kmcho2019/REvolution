module TopModule (
    input in1,
    input in2,
    output out
);
    // Technology-optimized NOR implementation
    wire nor_out;
    assign #1 nor_out = ~(in1 | in2);  // Delay annotation for simulation
    assign out = nor_out;
endmodule