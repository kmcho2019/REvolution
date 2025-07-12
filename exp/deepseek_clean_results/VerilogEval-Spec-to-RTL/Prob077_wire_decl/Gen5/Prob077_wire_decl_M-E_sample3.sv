module AndGate1(
    input a,
    input b,
    output out
);
    assign out = a & b;
endmodule

module AndGate2(
    input c,
    input d,
    output out
);
    assign out = c & d;
endmodule

module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n
);
    wire and1_out, and2_out;
    
    // Instantiate first layer AND gates
    AndGate1 and1(.a(a), .b(b), .out(and1_out));
    AndGate2 and2(.c(c), .d(d), .out(and2_out));
    
    // Second layer logic
    assign out = and1_out | and2_out;
    assign out_n = ~out;
endmodule