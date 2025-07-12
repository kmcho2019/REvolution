module TopModule (
    input in,
    output out
);
    // Simple NOT gate implementation
    // Drive strength can be adjusted if needed
    assign out = ~in;
    
    /* For power-gated version (when part of larger design):
    input en,
    assign out = en ? ~in : 1'bz;
    */
endmodule