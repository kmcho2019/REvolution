module TopModule (
    input a,
    input b,
    output out_assign,
    output out_alwaysblock
);

    // Compute AND once
    wire and_result = a & b;

    // Drive outputs with the same signal
    assign out_assign = and_result;
    assign out_alwaysblock = and_result;

endmodule