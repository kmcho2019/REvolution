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
    // Pack inputs into array for indexed access
    wire [7:0] vals [0:3];
    assign vals[0] = a;
    assign vals[1] = b;
    assign vals[2] = c;
    assign vals[3] = d;

    // Number of inputs and intermediate stages:
    // Stage 0: 4 inputs
    // Stage 1: 2 outputs after pairwise min
    // Stage 2: 1 output final min
    //
    // We'll build wires to hold intermediate results per stage.
    // Stage 1 wires: 2 elements
    wire [7:0] stage1 [0:1];

    // Instantiate min2 modules for stage 1: compare (vals[0], vals[1]) and (vals[2], vals[3])
    genvar i;
    generate
        for(i = 0; i < 2; i = i + 1) begin : gen_stage1
            min2 cmp (
                .x(vals[2*i]),
                .y(vals[2*i + 1]),
                .z(stage1[i])
            );
        end
    endgenerate

    // Stage 2: final minimum between stage1[0] and stage1[1]
    min2 cmp_final(
        .x(stage1[0]),
        .y(stage1[1]),
        .z(min)
    );

endmodule