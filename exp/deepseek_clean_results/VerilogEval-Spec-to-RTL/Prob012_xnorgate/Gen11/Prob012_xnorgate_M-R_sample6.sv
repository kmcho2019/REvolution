module TopModule (
    input a,
    input b,
    output out
);
    wire xor_out;
    
    xor(xor_out, a, b);  // XOR gate
    not(out, xor_out);    // Inverter to make XNOR
endmodule