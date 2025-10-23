module TopModule (
    input in,
    output out
);
    wire in_n;
    wire out_p, out_n;
    
    // Create complementary signals
    assign in_n = ~in;
    
    // Transmission gate logic
    assign out_p = in_n ? 1'b1 : 1'bz;
    assign out_n = in ? 1'b0 : 1'bz;
    
    // Combine the outputs
    assign out = out_p & out_n;
endmodule