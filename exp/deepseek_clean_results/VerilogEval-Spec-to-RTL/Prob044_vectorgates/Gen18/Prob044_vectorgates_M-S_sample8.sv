module TopModule (
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);
    
    // Bitwise OR
    assign out_or_bitwise = a | b;
    
    // Logical OR (OR-reduce both inputs then OR them)
    assign out_or_logical = |a || |b;
    
    // Vector NOT (b in upper bits, a in lower bits)
    assign out_not = {~b, ~a};

endmodule