module TopModule(
    input x,
    input y,
    output z
);
    assign z = ~(x ^ y); // Directly using XNOR logic
endmodule