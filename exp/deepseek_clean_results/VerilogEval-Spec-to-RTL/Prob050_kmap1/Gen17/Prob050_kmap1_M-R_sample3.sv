module TopModule (
    input a,
    input b,
    input c,
    output out
);
    wire bc_or;
    
    // First compute the OR of b and c
    assign bc_or = b | c;
    
    // Then select between 1 and bc_or based on 'a'
    assign out = a ? 1'b1 : bc_or;
endmodule