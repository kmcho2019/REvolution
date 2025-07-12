module TopModule(output out);
    // Explicit constant definition for maintainability
    localparam CONSTANT_ZERO = 1'b0;
    
    // Direct assignment for optimal implementation
    assign out = CONSTANT_ZERO;
endmodule