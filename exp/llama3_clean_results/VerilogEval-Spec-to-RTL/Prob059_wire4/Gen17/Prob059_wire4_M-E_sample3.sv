module TopModule(
    input  a,
    input  b,
    input  c,
    output w,
    output x,
    output y,
    output z
);
    wire int_a, int_b, int_c; // Internal wires to connect inputs to outputs
    
    // Assign inputs to internal wires
    assign int_a = a;
    assign int_b = b;
    assign int_c = c;
    
    // Assign internal wires to outputs
    assign w = int_a;
    assign x = int_b;
    assign y = int_b;
    assign z = int_c;
endmodule