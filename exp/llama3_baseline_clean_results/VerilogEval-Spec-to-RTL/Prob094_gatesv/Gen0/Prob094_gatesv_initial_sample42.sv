module TopModule(
    input  [3:0] in,
    output [3:1] out_both,
    output [2:0] out_any,
    output [3:0] out_different
);

    // Calculate out_both
    assign out_both[3] = 1'b0; // As per the problem statement, we don't need this but for consistency
    assign out_both[2] = in[2] & in[3];
    assign out_both[1] = in[1] & in[2];
    assign out_both[0] = in[0] & in[1];

    // Calculate out_any
    // We only need to calculate up to out_any[2] since out_any[0] is not needed
    assign out_any[2] = in[2] | in[1];
    assign out_any[1] = in[1] | in[0];
    assign out_any[0] = in[0] | in[3]; // Considering wrap-around for consistency, though not strictly necessary

    // Calculate out_different
    // We consider the vector as wrapping around for out_different
    assign out_different[3] = in[3] ^ in[0]; // in[3]'s left neighbor is in[0] due to wrap-around
    assign out_different[2] = in[2] ^ in[3];
    assign out_different[1] = in[1] ^ in[2];
    assign out_different[0] = in[0] ^ in[1];

endmodule