module TopModule (
    input a,
    input b,
    output out_assign,
    output out_alwaysblock
);
    // AND gate using assign statement
    assign out_assign = a & b;
    
    // AND gate using always block
    reg out_always;
    always @(*) begin
        out_always = a & b;
    end
    assign out_alwaysblock = out_always;
    
    // Simple verification (will be optimized away in synthesis)
    wire verification_ok = (out_assign == out_alwaysblock);
    
    // Simulation check
    initial begin
        $monitor("At time %t, verification: %s", 
                $time, 
                verification_ok ? "PASS" : "FAIL");
    end
endmodule