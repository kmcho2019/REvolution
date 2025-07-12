module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // Calculate out_both
    assign out_both[99] = 1'b0;  // MSB has no neighbor to the left
    assign out_both[98:0] = in[98:0] & in[99:1];

    // Calculate out_any
    assign out_any[0] = 1'b0;  // LSB has no neighbor to the right
    assign out_any[99:1] = in[99:1] | in[98:0];

    // Calculate out_different
    assign out_different[99:1] = in[99:1] ^ in[98:0];
    assign out_different[0] = in[0] ^ in[99];  // Wrap around for LSB

endmodule