module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n
);
    // Declare intermediate wires
    wire and1_out, and2_out;
    
    // Instantiate gate modules
    AND_GATE and1(.in1(a), .in2(b), .out(and1_out));
    AND_GATE and2(.in1(c), .in2(d), .out(and2_out));
    OR_GATE or1(.in1(and1_out), .in2(and2_out), .out(out));
    NOT_GATE not1(.in(out), .out(out_n));
endmodule

// Basic AND gate module
module AND_GATE (
    input in1,
    input in2,
    output out
);
    assign out = in1 & in2;
endmodule

// Basic OR gate module
module OR_GATE (
    input in1,
    input in2,
    output out
);
    assign out = in1 | in2;
endmodule

// Basic NOT gate module
module NOT_GATE (
    input in,
    output out
);
    assign out = ~in;
endmodule