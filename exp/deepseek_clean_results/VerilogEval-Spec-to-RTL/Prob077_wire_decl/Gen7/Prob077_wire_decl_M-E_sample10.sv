module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n
);
    // Intermediate wires for AND gate outputs
    wire and1_out, and2_out;
    
    // First layer: AND gates with 1ns delay
    and #(1.0) AND1 (and1_out, a, b);
    and #(1.0) AND2 (and2_out, c, d);
    
    // Second layer: OR gate with 0.8ns delay
    or #(0.8) OR1 (out, and1_out, and2_out);
    
    // Output inversion with 0.5ns delay
    not #(0.5) INV1 (out_n, out);
endmodule