module TopModule(input a, b, output out);
    wire transmission_out;
    
    // Transmission gate implementation of AND
    tranif1 tg1(a, transmission_out, b);
    tranif0 tg0(a, transmission_out, b);
    
    // Weak pull-down when transmission gate is off
    pulldown(transmission_out);
    
    // Output buffer (optional, depending on load requirements)
    buf b1(out, transmission_out);
endmodule