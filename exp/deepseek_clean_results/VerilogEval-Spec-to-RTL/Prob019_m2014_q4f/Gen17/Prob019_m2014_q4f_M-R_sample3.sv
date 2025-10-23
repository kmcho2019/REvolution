// Option 1: Continuous assignment (original)
module TopModule (
    input in1,
    input in2,
    output out
);
    assign out = in1 & ~in2;
endmodule

// Option 2: Always block procedural style
module TopModule (
    input in1,
    input in2,
    output reg out
);
    always @(*) begin
        out = in1 & ~in2;
    end
endmodule

// Option 3: Gate-level structural style
module TopModule (
    input in1,
    input in2,
    output out
);
    wire not_in2;
    
    not inv1(not_in2, in2);
    and and1(out, in1, not_in2);
endmodule