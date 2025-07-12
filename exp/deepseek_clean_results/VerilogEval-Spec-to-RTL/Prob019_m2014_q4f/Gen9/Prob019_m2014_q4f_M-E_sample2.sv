module TopModule (
    input in1,
    input in2,
    output out
);
    wire in2_bar;
    wire tg_out;
    
    // Inverter for in2
    not (in2_bar, in2);
    
    // Transmission gate implementation
    tranif1 (tg_out, in2_bar, in1);
    
    // Weak keeper when transmission gate is off
    pullup (weak1) p1(out);
    pulldown (weak0) p2(out);
    
    // Connect transmission gate output
    assign out = in1 ? tg_out : 1'b0;
endmodule