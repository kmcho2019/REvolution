module TopModule (
    input a,
    input b,
    input c,
    output out
);
    wire a_inv, b_inv, c_inv;
    wire and_inv;
    
    assign a_inv = ~a;
    assign b_inv = ~b;
    assign c_inv = ~c;
    assign and_inv = ~(a_inv & b_inv & c_inv);
    assign out = and_inv;
endmodule