module TopModule (
    input in1,
    input in2,
    output out
);
    // Transmission gate implementation of NOR
    wire in1_n, in2_n;
    
    // Invert inputs (could be implemented with transistors if needed)
    not(in1_n, in1);
    not(in2_n, in2);
    
    // Transmission gate logic
    tranif1 pmos(out, 1'b0, in1_n);  // PMOS: connects to 0 when input is low
    tranif0 nmos(out, 1'b1, in2);    // NMOS: connects to 1 when input is high
    
    // The combination creates NOR behavior:
    // - When either input is high, output is pulled low
    // - Only when both inputs are low does output stay high
endmodule