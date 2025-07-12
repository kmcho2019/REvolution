module TopModule (input a,b,c, output w,x,y,z);
    // Simple wire connections
    assign w = a;       // a -> w
    assign z = c;       // c -> z
    assign x = b;       // b -> x
    assign y = b;       // b -> y
endmodule