module A(x, y, z);
    input x, y;
    output z;
    assign z = (x ^ y) & x;
endmodule

// Based on the waveform, Module B's output z seems to be 1 when both x and y are 0, or when both x and y are 1.
// Otherwise, z is 0. This can be represented as z = (x & y) | (~x & ~y).
module B(x, y, z);
    input x, y;
    output z;
    assign z = (x & y) | (~x & ~y);
endmodule

module top(x, y, z);
    input x, y;
    output z;
    wire out_A1, out_B1, out_A2, out_B2, out_OR, out_AND;
    
    A A1(x, y, out_A1);
    B B1(x, y, out_B1);
    A A2(x, y, out_A2);
    B B2(x, y, out_B2);
    
    or or_gate(out_OR, out_A1, out_B1);
    and and_gate(out_AND, out_A2, out_B2);
    xor xor_gate(z, out_OR, out_AND);
endmodule