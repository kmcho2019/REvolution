module min2(
    input  [7:0] x,
    input  [7:0] y,
    output [7:0] z
);
    assign z = (x < y) ? x : y;
endmodule

module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    input  [7:0] c,
    input  [7:0] d,
    output [7:0] min
);

    // Pack inputs into an array for indexing
    wire [7:0] vals [0:3];
    assign vals[0] = a;
    assign vals[1] = b;
    assign vals[2] = c;
    assign vals[3] = d;

    // Stage 1 outputs (minimum of input pairs)
    wire [7:0] stage1 [0:1];
    // Stage 2 output (minimum of stage1 outputs)
    wire [7:0] stage2;

    genvar i;
    generate
        // First stage: compare pairs (0,1) and (2,3)
        for (i = 0; i < 2; i = i + 1) begin : gen_stage1
            min2 u_min2 (
                .x(vals[2*i]),
                .y(vals[2*i+1]),
                .z(stage1[i])
            );
        end
    endgenerate

    // Second stage: compare the two results from stage1
    min2 u_min2_final (
        .x(stage1[0]),
        .y(stage1[1]),
        .z(stage2)
    );

    assign min = stage2;

endmodule