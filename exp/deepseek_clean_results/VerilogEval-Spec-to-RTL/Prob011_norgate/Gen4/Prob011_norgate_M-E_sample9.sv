module TopModule(
    input a,
    input b,
    output out
);
    wire out_n;
    
    // PMOS network (pull-up)
    assign out_n = (a === 1'b0 && b === 1'b0) ? 1'b0 : 1'bz;
    
    // NMOS network (pull-down)
    assign out_n = (a === 1'b1 || b === 1'b1) ? 1'b1 : 1'bz;
    
    // Inverting output to get correct NOR function
    assign out = ~out_n;
endmodule