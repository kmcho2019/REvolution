module TopModule (
    input in,
    output out
);
    // Transmission gate implementation with always-on enable
    wire en = 1'b1;  // Always enabled for combinational behavior
    
    // Transmission gate behavior
    assign out = en ? in : 1'bz;
    
    // Optional: Weak keeper to prevent floating output
    // when enable is off (not needed in this case but shows extensibility)
    // pullup (weak1) p(out);
    // pulldown (weak0) n(out);
endmodule