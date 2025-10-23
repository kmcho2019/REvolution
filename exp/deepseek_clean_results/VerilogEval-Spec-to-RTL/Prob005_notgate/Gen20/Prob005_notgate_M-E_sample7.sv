module TopModule (
    input in,
    output out
);
    // PMOS switch (conducts when gate is 0)
    wire pmos_out = (in == 1'b0) ? 1'b1 : 1'bz;
    
    // NMOS switch (conducts when gate is 1)
    wire nmos_out = (in == 1'b1) ? 1'b0 : 1'bz;
    
    // Combine the outputs
    assign out = pmos_out & nmos_out;
endmodule