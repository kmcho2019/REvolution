module TopModule(
    input a,
    input b,
    output out
);
    // Optimal implementation - single AND operation
    assign out = a & b;
    
    // Alternative for technology mapping (commented out as it provides no PPA benefit)
    // AND2X1 U1 (.A(a), .B(b), .Y(out));  // If standard cell available
endmodule