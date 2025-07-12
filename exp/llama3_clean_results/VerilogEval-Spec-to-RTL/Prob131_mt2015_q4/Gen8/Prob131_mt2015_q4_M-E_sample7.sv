module CoreModule(x, y, out_a, out_b);
    input x, y;
    output out_a, out_b;
    assign out_a = (x ^ y) & x; // Output of Module A
    assign out_b = x == y; // Simplified output of Module B
endmodule

module TopModule(x, y, z);
    input x, y;
    output z;
    wire core_out_a, core_out_b;
    
    CoreModule core(x, y, core_out_a, core_out_b);
    
    assign z = (core_out_a | core_out_b) ^ (core_out_a & core_out_b);
endmodule