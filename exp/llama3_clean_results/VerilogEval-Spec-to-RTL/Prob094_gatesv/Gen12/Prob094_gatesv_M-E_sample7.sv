module TopModule(
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // Stage 1: out_both
    wire [3:0] out_both_stage;
    assign out_both_stage[0] = in[0] & in[1];
    assign out_both_stage[1] = in[1] & in[2];
    assign out_both_stage[2] = in[2] & in[3];
    assign out_both_stage[3] = 1'b0; // Since out_both[3] is not needed

    // Stage 2: out_any
    wire [3:0] out_any_stage;
    assign out_any_stage[0] = 1'b1; // Since out_any[0] is always 1 if in[0] is 1
    assign out_any_stage[1] = in[1] | in[0];
    assign out_any_stage[2] = in[2] | in[1];
    assign out_any_stage[3] = in[3] | in[2];

    // Stage 3: out_different
    wire [3:0] out_different_stage;
    assign out_different_stage[0] = in[0] ^ in[3];
    assign out_different_stage[1] = in[1] ^ in[0];
    assign out_different_stage[2] = in[2] ^ in[1];
    assign out_different_stage[3] = in[3] ^ in[2];

    // Output assignments
    assign out_both = out_both_stage;
    assign out_any = out_any_stage;
    assign out_different = out_different_stage;

endmodule