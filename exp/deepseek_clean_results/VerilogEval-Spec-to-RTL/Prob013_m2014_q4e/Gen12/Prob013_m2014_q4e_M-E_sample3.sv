module TopModule (
    input in1,
    input in2,
    output out
);
    // CMOS NOR gate implementation
    wire out_n;
    
    // Pull-up network (series PMOS)
    assign out = (in1 == 1'b0 && in2 == 1'b0) ? 1'b1 : 1'bz;
    
    // Pull-down network (parallel NMOS)
    assign out = (in1 == 1'b1 || in2 == 1'b1) ? 1'b0 : 1'bz;
    
    // Final output (modeling the wired connection)
    assign out = (out === 1'bz) ? 1'b1 : out;
endmodule