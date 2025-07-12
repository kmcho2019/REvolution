// Alternative 1: Using always block
module TopModule(
    input a,
    input b,
    output reg out
);
    always @(*) begin
        out = a & b;
    end
endmodule

// Alternative 2: Using gate primitive
/*
module TopModule(
    input a,
    input b,
    output out
);
    and g1(out, a, b);
endmodule
*/