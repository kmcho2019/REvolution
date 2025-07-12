module TopModule (
    input  in1,
    input  in2,
    input  in3,
    output out
);
    // Implement the function using equality and XOR for potential synthesis optimization
    assign out = (in1 == in2) ^ in3;
endmodule