module TopModule (
    input in1,
    input in2,
    output out
);
    // Internal nodes
    wire pullup, pulldown;
    
    // PMOS transistors (active low)
    // Pull-up network: OR structure (series PMOS)
    assign pullup = (~in1 & ~in2) ? 1'b1 : 1'bz;
    
    // NMOS transistors (active high)
    // Pull-down network: NOR structure (parallel NMOS)
    assign pulldown = (in1 | in2) ? 1'b0 : 1'bz;
    
    // Output combines both networks
    assign out = (pullup === 1'b1) ? 1'b1 :
                 (pulldown === 1'b0) ? 1'b0 :
                 1'bx; // handle contention case
endmodule