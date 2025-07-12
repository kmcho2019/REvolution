module TopModule(
    input  in1,
    input  in2,
    output out
);
    // Implementing a 2-input NOR gate using a direct assign statement
    // with bitwise NOT and OR operations for simplicity and efficiency.
    assign out = ~(in1 | in2);
endmodule