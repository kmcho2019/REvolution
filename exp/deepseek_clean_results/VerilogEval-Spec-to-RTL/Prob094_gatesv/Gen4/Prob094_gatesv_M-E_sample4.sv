module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // out_both: hierarchical pair processing
    assign out_both[2] = in[2] & in[3];
    assign out_both[1] = in[1] & in[2];
    assign out_both[0] = in[0] & in[1];
    assign out_both[3] = 1'b0;  // undefined per spec

    // out_any: hierarchical pair processing in opposite direction
    assign out_any[3] = in[3] | in[2];
    assign out_any[2] = in[2] | in[1];
    assign out_any[1] = in[1] | in[0];
    assign out_any[0] = 1'b0;   // undefined per spec

    // out_different: circular XOR using rotated input
    wire [3:0] rotated_in = {in[0], in[3:1]};
    assign out_different = in ^ rotated_in;

endmodule