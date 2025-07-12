// Primary implementation - Optimal NOT gate (best PPA)
module TopModule (
    input in,
    output out
);
    assign out = ~in;  // Minimal continuous assignment - optimal for PPA
endmodule

/* Alternative implementation - Functional style (for demonstration)
module TopModule (
    input in,
    output out
);
    // Function-based inversion (procedural style)
    function automatic logic invert(input a);
        return ~a;
    endfunction
    
    assign out = invert(in);  // Function call implementation
endmodule
*/