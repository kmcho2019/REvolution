module TopModule (
    input a,
    input b,
    output out
);
    // XNOR implementation using transmission gate logic
    wire a_bar;
    wire tg_out;
    
    // Inverter for a
    not (a_bar, a);
    
    // Transmission gate implementation
    assign tg_out = b ? a : a_bar;
    
    // Buffer the output (important in real implementations)
    buf (out, tg_out);
endmodule