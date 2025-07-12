module TopModule(input in, output out);
    // Transmission gate implementation
    tranif1 tg(out, in, 1'b1);  // Always enabled transmission gate
    
    // Alternative implementation using switch-level modeling
    // tran tg(out, in);  // Bi-directional pass transistor
    
    // Note: In real designs, we might add pullup/pulldown resistors
    // to handle floating nodes when the gate is disabled
endmodule