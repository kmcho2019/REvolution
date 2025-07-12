module HybridModule(x, y, z);
    input x, y;
    output z;
    wire a_out, b_out, or_out, and_out;
    
    // ModuleA logic: z = (x^y) & x
    assign a_out = (x ^ y) & x;
    
    // Simplified ModuleB logic: z = (x == y)
    assign b_out = (x == y);
    
    // Combining outputs as per the TopLevel module description
    assign or_out = a_out | b_out;
    assign and_out = a_out & b_out;
    
    // Final output through XOR operation
    assign z = or_out ^ and_out;
endmodule

// Testbench for verification
module tb_HybridModule;
    reg x, y;
    wire z;
    HybridModule HM(x, y, z);
    
    initial begin
        $monitor("x = %b, y = %b, z = %b", x, y, z);
        x = 0; y = 0; #10;
        x = 0; y = 1; #10;
        x = 1; y = 0; #10;
        x = 1; y = 1; #10;
        $finish;
    end
endmodule