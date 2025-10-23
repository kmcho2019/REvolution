module barrel_shifter(
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);

    // Internal wires between shift stages
    wire [7:0] stage1_out;
    wire [7:0] stage2_out;

    // Stage 1: 4-bit shift (controlled by ctrl[2])
    shift_stage #(.SHIFT_AMOUNT(4)) stage1 (
        .in(in),
        .enable(ctrl[2]),
        .out(stage1_out)
    );

    // Stage 2: 2-bit shift (controlled by ctrl[1])
    shift_stage #(.SHIFT_AMOUNT(2)) stage2 (
        .in(stage1_out),
        .enable(ctrl[1]),
        .out(stage2_out)
    );

    // Stage 3: 1-bit shift (controlled by ctrl[0])
    shift_stage #(.SHIFT_AMOUNT(1)) stage3 (
        .in(stage2_out),
        .enable(ctrl[0]),
        .out(out)
    );

endmodule

// Parameterized shift stage module
module shift_stage #(
    parameter SHIFT_AMOUNT = 1
)(
    input [7:0] in,
    input enable,
    output [7:0] out
);
    assign out = enable ? {in[7-SHIFT_AMOUNT:0], in[7:8-SHIFT_AMOUNT]} : in;
endmodule