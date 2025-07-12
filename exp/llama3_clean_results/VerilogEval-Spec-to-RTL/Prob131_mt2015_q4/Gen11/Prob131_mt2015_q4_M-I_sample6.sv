module ModuleA(x, y, z);
    input x, y;
    output z;
    assign z = x & (!y); // Optimized logic
endmodule

module ModuleB(x, y, z);
    input x, y;
    output z;
    assign z = (x == y); // Already optimized
endmodule

module TopModule(x, y, z);
    input x, y;
    output z;

    ModuleA A(x, y, z);
    ModuleB B(x, y, z);

    // Directly compute output 'z' using the optimized logic
    assign z = (x & (!y)) | (x == y);
endmodule