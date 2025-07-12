module TopModule (
    input in1,
    input in2,
    output out
);
    // Clear NOR operation using continuous assignment
    assign out = ~(in1 | in2);
endmodule