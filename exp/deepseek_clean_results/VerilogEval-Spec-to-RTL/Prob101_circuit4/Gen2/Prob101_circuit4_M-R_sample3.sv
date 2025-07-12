module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    // Gate-level implementation of OR operation
    wire nor_out;
    wire not_b, not_c;
    
    // First implement b OR c using De Morgan's laws:
    // b OR c = NOT(NOT b AND NOT c)
    
    not(not_b, b);
    not(not_c, c);
    nand(nor_out, not_b, not_c);  // This is equivalent to b OR c
    buf(q, nor_out);
endmodule