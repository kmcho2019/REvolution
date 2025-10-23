// Behavioral style implementation
module TopModule(
    input a,
    input b,
    output reg out
);
    always @(a or b) begin
        out = a & b;
    end
endmodule

/* Alternative implementations for reference:

// Structural style implementation
module TopModule(
    input a,
    input b,
    output out
);
    and g1(out, a, b);
endmodule

// Procedural style implementation
module TopModule(
    input a,
    input b,
    output out
);
    function automatic logic and_func(input a, input b);
        return a & b;
    endfunction
    
    assign out = and_func(a, b);
endmodule
*/