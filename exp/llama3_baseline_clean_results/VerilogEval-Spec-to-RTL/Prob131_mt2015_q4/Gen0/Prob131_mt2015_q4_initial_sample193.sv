module A(x, y, z);
    input x, y;
    output z;
    assign z = (x ^ y) & x;
endmodule

module B(x, y, z);
    input x, y;
    output z;
    assign z = ~(x ^ y);
endmodule

module top_level(x, y, z);
    input x, y;
    output z;
    wire z_A1, z_B1, z_A2, z_B2, z_OR, z_AND;
    
    A u_A1(x, y, z_A1);
    B u_B1(x, y, z_B1);
    A u_A2(x, y, z_A2);
    B u_B2(x, y, z_B2);
    
    assign z_OR = z_A1 | z_B1;
    assign z_AND = z_A2 & z_B2;
    assign z = z_OR ^ z_AND;
endmodule

module testbench();
    reg x, y;
    wire z;
    top_level u_top_level(x, y, z);
    
    initial begin
        $dumpvars;
        $monitor("x = %b, y = %b, z = %b", x, y, z);
        x = 0; y = 0;
        #5 x = 0; y = 0;
        #5 x = 0; y = 0;
        #5 x = 0; y = 0;
        #5 x = 0; y = 0;
        #5 x = 1; y = 0;
        #5 x = 1; y = 0;
        #5 x = 0; y = 1;
        #5 x = 0; y = 1;
        #5 x = 1; y = 1;
        #5 x = 1; y = 1;
        #5 x = 0; y = 0;
        #5 x = 0; y = 1;
        #5 x = 0; y = 1;
        #5 x = 1; y = 1;
        #5 x = 0; y = 1;
        #5 x = 0; y = 1;
        #5 x = 0; y = 1;
        #5 x = 1; y = 0;
        #10 $finish;
    end
endmodule