// Transmission gate based buffer implementation
module TopModule (
    input in,
    output out
);
    // Internal wire for the transmission gate output
    wire tg_out;
    
    // Transmission gate implementation
    tranif1 tg_n(out, in, 1'b1);  // NMOS pass transistor
    tranif0 tg_p(out, in, 1'b0);   // PMOS pass transistor
    
    // The combination acts as a perfect buffer
endmodule