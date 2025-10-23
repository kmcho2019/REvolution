module TopModule (
    input x,
    input y,
    output z
);
    wire xor_result;
    
    xor(xor_result, x, y);
    and(z, xor_result, x);
endmodule