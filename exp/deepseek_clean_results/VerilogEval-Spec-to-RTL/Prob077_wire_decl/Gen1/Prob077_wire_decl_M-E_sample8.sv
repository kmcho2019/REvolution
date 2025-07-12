module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n
);

    // Declare wires for interconnections
    wire and1_out, and2_out;
    
    // Instantiate first AND gate (a & b)
    AND2 and1 (
        .in1(a),
        .in2(b),
        .out(and1_out)
    );
    
    // Instantiate second AND gate (c & d)
    AND2 and2 (
        .in1(c),
        .in2(d),
        .out(and2_out)
    );
    
    // Instantiate OR gate
    OR2 or1 (
        .in1(and1_out),
        .in2(and2_out),
        .out(out)
    );
    
    // Inverted output
    assign out_n = ~out;

endmodule

// AND gate module
module AND2 (
    input in1,
    input in2,
    output out
);
    assign out = in1 & in2;
endmodule

// OR gate module
module OR2 (
    input in1,
    input in2,
    output out
);
    assign out = in1 | in2;
endmodule