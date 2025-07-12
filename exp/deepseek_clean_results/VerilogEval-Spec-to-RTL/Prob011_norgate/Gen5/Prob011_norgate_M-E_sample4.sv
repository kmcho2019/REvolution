module TopModule (
    input a,
    input b,
    output out
);
    // PMOS pull-up network (active low)
    wire pull_up = ~(a | b);
    
    // NMOS pull-down network (active high)
    wire pull_down = a | b;
    
    // Transmission gate style output
    assign out = pull_up ? 1'b1 : (pull_down ? 1'b0 : 1'bz);
endmodule