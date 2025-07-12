module TopModule(
    input  logic a,
    input  logic b,
    output logic q
);
    assign q = a & b; // Using bitwise AND operator '&' instead of logical '&&' for simplicity and potential area/power efficiency.
endmodule