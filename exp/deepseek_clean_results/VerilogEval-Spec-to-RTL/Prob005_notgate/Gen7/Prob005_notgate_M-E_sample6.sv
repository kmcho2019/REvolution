module TopModule (
    input in,
    output out
);
    // Transmission gate style NOT implementation
    wire in_n;
    
    // Pull-down network (NMOS)
    assign out = in_n ? 1'b0 : 1'bz;
    
    // Pull-up network (PMOS)
    assign out = in ? 1'bz : 1'b1;
    
    // Inverter to create in_n
    assign in_n = ~in;
endmodule