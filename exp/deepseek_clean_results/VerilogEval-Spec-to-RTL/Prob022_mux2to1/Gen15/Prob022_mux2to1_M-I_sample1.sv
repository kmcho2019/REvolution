module TopModule (
    input a,
    input b,
    input sel,
    output out
);
    wire sel_n;
    
    // Generate complementary select signal
    assign sel_n = ~sel;
    
    // Transmission gate implementation
    assign out = (sel_n) ? a : b;
endmodule