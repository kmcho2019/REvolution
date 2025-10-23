module TopModule (
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);
    // Bitwise OR operation
    assign out_or_bitwise = a | b;
    
    // Logical OR operation (reduction of bitwise OR)
    assign out_or_logical = |(a | b);
    
    // NOT operations with b in upper bits [5:3], a in lower bits [2:0]
    assign out_not = {~b, ~a};
endmodule