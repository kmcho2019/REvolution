module TopModule (
    input in,
    output out
);
    // Optimal implementation using Verilog primitive
    not U1 (out, in);
    
    // Alternative procedural implementation:
    // always @(in) begin
    //     out = ~in;
    // end
endmodule