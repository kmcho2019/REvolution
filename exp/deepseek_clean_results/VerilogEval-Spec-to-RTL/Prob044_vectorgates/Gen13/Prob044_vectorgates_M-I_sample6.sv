module TopModule (
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);
    // Bitwise OR implementation (direct)
    assign out_or_bitwise = a | b;
    
    // More efficient logical OR: first combine then reduce
    assign out_or_logical = |(a | b);
    
    // Shared NOT computation with b in upper bits [5:3], a in lower bits [2:0]
    assign out_not = {~b, ~a};
endmodule