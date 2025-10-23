module TopModule(
    input x,
    input y,
    output z
);
    // After complete Boolean simplification
    assign z = ~y;
endmodule