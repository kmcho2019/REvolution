// Version 1: Procedural Implementation
module TopModule(
    input a,
    input b,
    output reg out
);
    // Truth table remains the same:
    // a b | out
    // 0 0 | 1
    // 0 1 | 0
    // 1 0 | 0
    // 1 1 | 0
    always @(a or b) begin
        out = ~(a | b);
    end
endmodule

// Version 2: Gate-Level Implementation
/*
module TopModule(
    input a,
    input b,
    output out
);
    // Structural implementation using primitive gates
    wire or_out;
    or (or_out, a, b);
    not (out, or_out);
endmodule
*/