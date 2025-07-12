module TopModule (
    input in1,
    input in2,
    output out
);
    // Structural implementation using Verilog primitive gates
    wire or_out;
    
    // First stage: OR gate
    or (or_out, in1, in2);
    
    // Second stage: NOT gate (completing the NOR function)
    not (out, or_out);
endmodule