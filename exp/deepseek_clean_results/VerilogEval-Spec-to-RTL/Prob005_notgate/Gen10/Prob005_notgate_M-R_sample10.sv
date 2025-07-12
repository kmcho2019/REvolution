// Alternative 3: Continuous assignment with explicit wire
module TopModule (
    input in,
    output out
);
    wire not_out;
    assign not_out = ~in;
    assign out = not_out;
endmodule

// Alternative 4: Using a function
/*
module TopModule (
    input in,
    output out
);
    function automatic logic not_func(input a);
        not_func = ~a;
    endfunction
    
    assign out = not_func(in);
endmodule
*/