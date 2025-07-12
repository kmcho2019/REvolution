module TopModule (
    input in,
    output out
);
    // Transmission gate implementation with always-on enable
    wire en = 1'b1;  // Tie enable permanently high
    
    // Transmission gate behavior
    assign out = en ? in : 1'bz;
    
    // Note: In real implementations, this would need proper
    //       pull-up/down when disabled, but omitted here
    //       for simplicity since we're always enabled
endmodule