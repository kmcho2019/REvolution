module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // out_both: AND current bit with left neighbor
    assign out_both[99] = 1'b0;  // Special case for MSB
    assign out_both[98:0] = in[98:0] & in[99:1];

    // out_any: OR current bit with right neighbor
    assign out_any[0] = 1'b0;    // Special case for LSB
    assign out_any[99:1] = in[99:1] | in[98:0];

    // out_different: XOR current bit with left neighbor (wrap-around)
    wire [99:0] in_shifted = {in[0], in[99:1]};  // Left shift with wrap-around
    assign out_different = in ^ in_shifted;

endmodule