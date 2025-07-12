module TopModule (
    output one
);
    // Alternative implementation using logic gates
    // Demonstrates constant generation through logic
    wire const_a = 1'b1;
    wire const_b = 1'b1;
    
    or g1(one, const_a, const_b);
endmodule