module TopModule (
    input  a,
    input  b,
    output out
);
    // Directly implement the NOR operation using assign for optimal power and area
    assign out = ~(a | b);
endmodule