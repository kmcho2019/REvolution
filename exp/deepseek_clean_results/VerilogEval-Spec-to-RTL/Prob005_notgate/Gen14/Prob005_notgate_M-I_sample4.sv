module TopModule (
    input in,
    output out
);
    // Original optimal implementation remains best
    assign out = ~in;
    
    // Alternative implementations (commented out as they're not better for this case):
    // 1. Using a buffer cell (would need library support)
    // NOT_CELL not_inst (.A(in), .Y(out));
    
    // 2. Using a tri-state buffer (not better here)
    // assign out = in ? 1'b0 : 1'b1;
    
    // 3. Using a lookup table (overkill for NOT)
    // reg out_reg;
    // always @(*) out_reg = ~in;
    // assign out = out_reg;
endmodule