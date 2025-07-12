module TopModule(
    input x,
    input y,
    output z
);
    assign z = x | y;  // Simplified to just OR operation
endmodule