module TopModule(
    input x,
    input y,
    output z
);
    // Direct implementation of simplified logic
    assign z = ~(x | y);
endmodule