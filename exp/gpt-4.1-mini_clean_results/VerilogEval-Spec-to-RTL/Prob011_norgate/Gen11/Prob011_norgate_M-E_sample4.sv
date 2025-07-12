module TopModule (
    input  a,
    input  b,
    output out
);
    wire or_result;
    assign or_result = a | b;   // OR the inputs
    assign out = ~or_result;    // Invert the OR result to get NOR
endmodule