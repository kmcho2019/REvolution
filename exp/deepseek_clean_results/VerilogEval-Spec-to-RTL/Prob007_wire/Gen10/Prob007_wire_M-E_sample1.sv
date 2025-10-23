module TopModule(input in, output out);
    wire en = 1'b1;  // Transmission gate always enabled
    wire in_bar;
    
    // PMOS side (passes strong 1)
    bufif1 pmos(out, in, en);
    
    // NMOS side (passes strong 0)
    not not1(in_bar, in);
    notif1 nmos(out, in_bar, en);
endmodule