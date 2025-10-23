// Refactored 1: Dataflow style with continuous assignment
module TopModule (
    input in,
    output out
);
    assign out = ~in;
endmodule

// Refactored 2: Using a function (procedural style)
/*
module TopModule (
    input in,
    output out
);
    function automatic logic invert(input a);
        return ~a;
    endfunction
    
    assign out = invert(in);
endmodule
*/