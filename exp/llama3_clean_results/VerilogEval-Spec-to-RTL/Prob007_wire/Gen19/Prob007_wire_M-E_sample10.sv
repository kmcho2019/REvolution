module TopModule(
    input  in,
    output out
);
    
    // Internal signal for the select line of the MUX
    wire sel;
    
    // Assign the select line to a constant value (0 or 1) to always select 'in'
    assign sel = 1'b0; // Selecting the first input (in) to pass through
    
    // 2-to-1 Multiplexer implementation
    assign out = (sel) ? 1'b0 : in; // When sel is 0, out = in; otherwise, out = 0

endmodule