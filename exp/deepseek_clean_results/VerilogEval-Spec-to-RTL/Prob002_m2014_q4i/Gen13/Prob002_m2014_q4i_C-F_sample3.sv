module TopModule (
    output out
);
    // Minimal synthesizable logic
    assign out = 1'b0;
    
    // Simulation-only clock generation for verification
`ifdef SIMULATION
    reg clk = 0;
    initial begin
        forever #5 clk = ~clk;
    end
`endif
endmodule