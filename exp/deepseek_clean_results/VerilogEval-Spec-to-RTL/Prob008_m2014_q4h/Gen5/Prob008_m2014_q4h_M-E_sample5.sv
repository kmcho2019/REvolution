module TopModule (
    input in,
    output out
);
    // Implement as a 2:1 mux with hardwired select
    // This is functionally equivalent to a wire but shows alternative implementation
    wire sel = 1'b1;  // Hardwired to always select input
    wire unused = 1'b0;  // Other mux input (unused)
    
    assign out = sel ? in : unused;
endmodule