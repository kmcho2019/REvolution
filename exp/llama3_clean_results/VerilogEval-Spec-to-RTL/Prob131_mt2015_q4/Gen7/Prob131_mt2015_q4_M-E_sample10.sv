module TopModule(x, y, z);
    input x, y;
    output z;

    // Directly compute the output z based on the insights from ModuleA and ModuleB
    assign z = (x & (x ^ y)) | (!x & !y);
endmodule