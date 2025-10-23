module TwoToOneMux(
    input  wire in0,
    input  wire in1,
    input  wire sel,
    output wire out
);
    assign out = sel ? in1 : in0;
endmodule

module TopModule(
    input  wire [255:0] in,
    input  wire [7:0]   sel,
    output wire         out
);
    // We have 8 levels (because 2^8 = 256).
    // Each level halves the number of candidates until 1 remains.

    // Declare an array of wires for each level:
    // level_wires[level] is the vector of signals at that level.
    // level 0 is the input 'in' (256 bits),
    // level 1 has 128 bits,
    // level 2 has 64 bits,
    // ...
    // level 8 has 1 bit (the output).

    // Using a generate loop with indexed arrays:
    // We'll create reg arrays to hold intermediate stage signals.
    // Using wire arrays with a packed dimension for each level.

    // Create a two-dimensional array to hold intermediate signals:
    // Since Verilog doesn't support arrays of vectors in plain wire syntax,
    // define each level as a wire vector of appropriate width.
    // Then use generate loops to instantiate TwoToOneMux modules connecting levels.

    // Level sizes:
    localparam LEVELS = 8;
    localparam integer WIDTHS[0:LEVELS] = '{256, 128, 64, 32, 16, 8, 4, 2, 1};

    wire [WIDTHS[0]-1:0] level0 = in;
    wire [WIDTHS[1]-1:0] level1;
    wire [WIDTHS[2]-1:0] level2;
    wire [WIDTHS[3]-1:0] level3;
    wire [WIDTHS[4]-1:0] level4;
    wire [WIDTHS[5]-1:0] level5;
    wire [WIDTHS[6]-1:0] level6;
    wire [WIDTHS[7]-1:0] level7;
    wire [WIDTHS[8]-1:0] level8;

    genvar lvl, i;

    generate
        // Level 1: 256 -> 128 muxes controlled by sel[0]
        for (i = 0; i < WIDTHS[1]; i = i + 1) begin : lvl1_muxes
            TwoToOneMux mux(
                .in0(level0[2*i]),
                .in1(level0[2*i+1]),
                .sel(sel[0]),
                .out(level1[i])
            );
        end

        // Level 2: 128 -> 64 muxes controlled by sel[1]
        for (i = 0; i < WIDTHS[2]; i = i + 1) begin : lvl2_muxes
            TwoToOneMux mux(
                .in0(level1[2*i]),
                .in1(level1[2*i+1]),
                .sel(sel[1]),
                .out(level2[i])
            );
        end

        // Level 3: 64 -> 32 muxes controlled by sel[2]
        for (i = 0; i < WIDTHS[3]; i = i + 1) begin : lvl3_muxes
            TwoToOneMux mux(
                .in0(level2[2*i]),
                .in1(level2[2*i+1]),
                .sel(sel[2]),
                .out(level3[i])
            );
        end

        // Level 4: 32 -> 16 muxes controlled by sel[3]
        for (i = 0; i < WIDTHS[4]; i = i + 1) begin : lvl4_muxes
            TwoToOneMux mux(
                .in0(level3[2*i]),
                .in1(level3[2*i+1]),
                .sel(sel[3]),
                .out(level4[i])
            );
        end

        // Level 5: 16 -> 8 muxes controlled by sel[4]
        for (i = 0; i < WIDTHS[5]; i = i + 1) begin : lvl5_muxes
            TwoToOneMux mux(
                .in0(level4[2*i]),
                .in1(level4[2*i+1]),
                .sel(sel[4]),
                .out(level5[i])
            );
        end

        // Level 6: 8 -> 4 muxes controlled by sel[5]
        for (i = 0; i < WIDTHS[6]; i = i + 1) begin : lvl6_muxes
            TwoToOneMux mux(
                .in0(level5[2*i]),
                .in1(level5[2*i+1]),
                .sel(sel[5]),
                .out(level6[i])
            );
        end

        // Level 7: 4 -> 2 muxes controlled by sel[6]
        for (i = 0; i < WIDTHS[7]; i = i + 1) begin : lvl7_muxes
            TwoToOneMux mux(
                .in0(level6[2*i]),
                .in1(level6[2*i+1]),
                .sel(sel[6]),
                .out(level7[i])
            );
        end

        // Level 8: 2 -> 1 mux controlled by sel[7]
        TwoToOneMux mux_final (
            .in0(level7[0]),
            .in1(level7[1]),
            .sel(sel[7]),
            .out(level8[0])
        );
    endgenerate

    assign out = level8[0];
endmodule