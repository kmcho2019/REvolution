// 2-to-1 Multiplexer submodule
module mux2X1(
    input   wire    sel,
    input   wire    a,
    input   wire    b,
    output  wire    out
);

    assign out = (sel)? b : a;

endmodule

// Barrel Shifter module
module barrel_shifter(
    input   wire    [7:0] in,
    input   wire    [2:0] ctrl,
    output  wire    [7:0] out
);

    // Stage 1: Shift by 4 positions based on ctrl[2]
    wire [7:0] stage1_out;
    mux2X1 stage1_mux[7:0] (
       .sel  (ctrl[2]),
       .a    (in),
       .b    ({in[3:0], 4'h0}), // Shift right by 4 positions
       .out  (stage1_out)
    );

    // Stage 2: Shift by 2 positions based on ctrl[1]
    wire [7:0] stage2_out;
    mux2X1 stage2_mux[7:0] (
       .sel  (ctrl[1]),
       .a    (stage1_out),
       .b    ({stage1_out[5:0], 2'h0}), // Shift right by 2 positions
       .out  (stage2_out)
    );

    // Stage 3: Shift by 1 position based on ctrl[0]
    wire [7:0] stage3_out;
    mux2X1 stage3_mux[7:0] (
       .sel  (ctrl[0]),
       .a    (stage2_out),
       .b    ({stage2_out[6:0], 1'h0}), // Shift right by 1 position
       .out  (stage3_out)
    );

    // Final output
    assign out = stage3_out;

endmodule