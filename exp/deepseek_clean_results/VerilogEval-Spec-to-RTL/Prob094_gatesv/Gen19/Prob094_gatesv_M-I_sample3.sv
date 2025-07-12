module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    wire [3:0] in_rotated = {in[0], in[3:1]};  // Rotated left by 1 for circular operations

    // out_both[2:0] = in[2:0] & in[3:1], out_both[3] is don't care
    assign out_both[2:0] = in[2:0] & in[3:1];
    assign out_both[3] = 1'b0;  // Explicitly set to 0 for clean synthesis

    // out_any[3:1] = in[3:1] | in[2:0], out_any[0] is don't care
    assign out_any[3:1] = in[3:1] | in[2:0];
    assign out_any[0] = 1'b0;   // Explicitly set to 0 for clean synthesis

    // out_different = in ^ in_rotated (circular difference)
    assign out_different = in ^ in_rotated;

endmodule