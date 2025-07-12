module TopModule (
    input  in,    // Input signal
    output out    // Inverted output
);
    // Optimal direct NOT implementation
    assign out = ~in;
    
    /* Alternative implementation options (commented out):
    // Option 1: Using a function (for verification)
    function automatic logic not_gate(input a);
        return ~a;
    endfunction
    assign out = not_gate(in);
    
    // Option 2: Parameterized version (for potential scaling)
    parameter WIDTH = 1;
    assign out = ~in;
    */
endmodule