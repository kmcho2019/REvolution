module TopModule(
    input a,
    input b,
    output out
);
    // Transmission gate style implementation
    wire nor_intermediate;
    
    // Pull-up network (series PMOS)
    assign nor_intermediate = (~a & ~b) ? 1'b1 : 1'bz;
    
    // Pull-down network (parallel NMOS)
    assign nor_intermediate = (a | b) ? 1'b0 : 1'bz;
    
    // Output buffer
    assign out = nor_intermediate;
endmodule