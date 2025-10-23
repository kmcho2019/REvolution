module TopModule (
    input  a,
    input  b,
    input  sel,
    output out
);
    // Explicit continuous assignment for clarity
    wire selected_a = ~sel & a;
    wire selected_b =  sel & b;
    
    // Combine selections
    assign out = selected_a | selected_b;
endmodule