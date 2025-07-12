module TopModule(
    input x,
    input y,
    output logic z
);
    // Directly assigning the expression ~(x ^ y) to z
    assign z = ~(x ^ y);
endmodule