module TopModule(
    input [3:0] x,
    output logic f
);

    // The condition for 'f' to be 1 is refined into two main scenarios:
    // 1. When x[3] is 1, 'f' should be 1 if either x[1] or x[2] (or both) are 1.
    // 2. When x[3] is 0, 'f' should be 1 only if x[0] is 1 and both x[1] and x[2] are 1.
    assign f = (x[3] & (x[1] | x[2])) | (x[0] & x[1] & x[2] & ~x[3]);

    // No further simplification seems possible without altering the logic's functionality.
    // However, this implementation already uses basic logical operations, which is efficient.
    // Further optimization would require a deeper analysis of the specific technology and constraints.

endmodule