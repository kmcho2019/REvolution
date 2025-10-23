module TopModule(
    input x,
    input y,
    output z
);
    // The most straightforward and efficient implementation of the logic
    assign z = ~(x ^ y);
endmodule