module TopModule(x, y, z);
    input x, y;
    output z;
    assign z = (x & (x ^ y)) | ((x & y) | (!x &!y));
endmodule