module TopModule(
    input  in,
    output out
);
    
    // The existing implementation is already optimal. 
    // Applying any synthesis directives or attributes here is tool-specific and might not be directly applicable in Verilog code.
    // For instance, some tools might allow specifying area or power constraints directly in the code, but this is highly tool-dependent.
    assign out = ~in;

endmodule