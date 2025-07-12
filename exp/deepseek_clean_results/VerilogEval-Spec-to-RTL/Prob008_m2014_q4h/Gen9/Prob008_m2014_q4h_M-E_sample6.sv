module TopModule (
    input in,
    output out
);
    // Transmission gate implementation
    wire ctrl_n, ctrl_p;
    
    // Always enable the transmission gate
    assign ctrl_n = 1'b0;  // GND
    assign ctrl_p = 1'b1;  // VDD
    
    // Transmission gate acts as a buffer when enabled
    tranif1(out, in, ctrl_p);
    tranif0(out, in, ctrl_n);
endmodule