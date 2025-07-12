// Option 1: Procedural Approach
module TopModule (
    input a,
    input b,
    output reg out
);
    always @(*) begin
        out = ~(a | b);
    end
endmodule

// Option 2: Gate-Level Implementation
/*
module TopModule (
    input a,
    input b,
    output out
);
    nor(out, a, b);
endmodule
*/