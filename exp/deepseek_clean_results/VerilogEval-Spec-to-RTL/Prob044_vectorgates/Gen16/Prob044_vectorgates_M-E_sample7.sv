module TopModule (
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);
    // Shared intermediate signals
    wire [2:0] not_a = ~a;
    wire [2:0] not_b = ~b;
    
    // Bitwise OR (direct operation)
    assign out_or_bitwise = a | b;
    
    // Logical OR (reduction of bitwise OR)
    assign out_or_logical = |out_or_bitwise;
    
    // Concatenated NOT outputs (b in upper bits)
    assign out_not = {not_b, not_a};
endmodule