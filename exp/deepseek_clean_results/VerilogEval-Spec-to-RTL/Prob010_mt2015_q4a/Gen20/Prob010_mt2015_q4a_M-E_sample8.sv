module TopModule (
    input x,
    input y,
    output z
);
    wire xor_out;
    
    xor xor_gate (xor_out, x, y);
    and and_gate (z, xor_out, x);
endmodule