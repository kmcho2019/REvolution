module TopModule(
    input  logic in,
    output logic out
);
    // The existing direct assignment is optimal for this functionality.
    // To potentially improve PPA metrics, we could consider using synthesis attributes or directives,
    // but without specific synthesis tool or target technology constraints, such optimizations are speculative.
    assign out = in;
endmodule