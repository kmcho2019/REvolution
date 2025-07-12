module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);
    // Sum is the parity (XOR) of all inputs
    assign sum = a ^ b ^ cin;
    
    // Carry is the majority of all inputs
    wire ab, bc, ca;
    and g1(ab, a, b);
    and g2(bc, b, cin);
    and g3(ca, cin, a);
    or  g4(cout, ab, bc, ca);
endmodule