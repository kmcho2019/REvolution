module HalfXor(
    input  a,
    input  b,
    output y
);
    assign y = a ^ b;
endmodule

module TopModule (
    input  [7:0] in,
    output       parity
);
    // Intermediate wires for XOR stages
    wire [3:0] stage1;
    wire [1:0] stage2;
    wire       stage3;

    // Stage 1: XOR pairs of input bits (8 inputs -> 4 outputs)
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : gen_stage1
            HalfXor hx(
                .a(in[2*i]),
                .b(in[2*i+1]),
                .y(stage1[i])
            );
        end
    endgenerate

    // Stage 2: XOR pairs of stage1 outputs (4 -> 2)
    generate
        for (i = 0; i < 2; i = i + 1) begin : gen_stage2
            HalfXor hx(
                .a(stage1[2*i]),
                .b(stage1[2*i+1]),
                .y(stage2[i])
            );
        end
    endgenerate

    // Stage 3: XOR the last two outputs to get final parity bit
    HalfXor hx_final (
        .a(stage2[0]),
        .b(stage2[1]),
        .y(stage3)
    );

    assign parity = stage3;
endmodule