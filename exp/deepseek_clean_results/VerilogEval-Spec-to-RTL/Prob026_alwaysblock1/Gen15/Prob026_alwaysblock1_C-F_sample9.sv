module TopModule (
    input a,
    input b,
    output out_assign,
    output out_alwaysblock
);
    // Continuous assignment implementation
    assign out_assign = a & b;
    
    // Proper combinational always block implementation
    always @(*) begin
        out_alwaysblock = a & b;
    end

    // Simulation-only verification
`ifdef SIMULATION
    always @(*) begin
        if (out_assign !== out_alwaysblock) begin
            $display("Error: AND gate mismatch at time %t", $time);
            $display("  Assign: %b, Always: %b", out_assign, out_alwaysblock);
        end
    end
`endif
endmodule