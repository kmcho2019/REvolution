module TopModule(
    input [255:0] in,
    input [7:0] sel,
    output out
);

    // Define a parameter for the number of input bits
    parameter NUM_INPUT_BITS = 256;

    // Calculate the number of levels in the tree
    parameter NUM_LEVELS = $clog2(NUM_INPUT_BITS);

    // Define a wire to store the selected output
    wire selected_out;

    // Instantiate the tree-based selection structure
    tree_mux #(.NUM_INPUT_BITS(NUM_INPUT_BITS), .NUM_LEVELS(NUM_LEVELS)) tree_mux_inst(
        .in(in),
        .sel(sel),
        .out(selected_out)
    );

    // Assign the selected output to the module output
    assign out = selected_out;

endmodule

// Define a module for the tree-based selection structure
module tree_mux #(
    parameter NUM_INPUT_BITS = 256,
    parameter NUM_LEVELS = $clog2(NUM_INPUT_BITS)
)(
    input [NUM_INPUT_BITS-1:0] in,
    input [7:0] sel,
    output out
);

    // Define wires to store the intermediate outputs
    wire [NUM_INPUT_BITS/2-1:0] level1_out;
    wire [NUM_INPUT_BITS/4-1:0] level2_out;
    wire [NUM_INPUT_BITS/8-1:0] level3_out;
    wire [NUM_INPUT_BITS/16-1:0] level4_out;
    wire [NUM_INPUT_BITS/32-1:0] level5_out;
    wire [NUM_INPUT_BITS/64-1:0] level6_out;
    wire [NUM_INPUT_BITS/128-1:0] level7_out;

    // Define the tree structure using generate blocks
    genvar i;
    generate
        for (i = 0; i < NUM_INPUT_BITS/2; i++) begin
            mux2to1 mux2to1_inst(
                .in0(in[i*2]),
                .in1(in[i*2+1]),
                .sel(sel[0]),
                .out(level1_out[i])
            );
        end
    endgenerate

    generate
        for (i = 0; i < NUM_INPUT_BITS/4; i++) begin
            mux2to1 mux2to1_inst(
                .in0(level1_out[i*2]),
                .in1(level1_out[i*2+1]),
                .sel(sel[1]),
                .out(level2_out[i])
            );
        end
    endgenerate

    generate
        for (i = 0; i < NUM_INPUT_BITS/8; i++) begin
            mux2to1 mux2to1_inst(
                .in0(level2_out[i*2]),
                .in1(level2_out[i*2+1]),
                .sel(sel[2]),
                .out(level3_out[i])
            );
        end
    endgenerate

    generate
        for (i = 0; i < NUM_INPUT_BITS/16; i++) begin
            mux2to1 mux2to1_inst(
                .in0(level3_out[i*2]),
                .in1(level3_out[i*2+1]),
                .sel(sel[3]),
                .out(level4_out[i])
            );
        end
    endgenerate

    generate
        for (i = 0; i < NUM_INPUT_BITS/32; i++) begin
            mux2to1 mux2to1_inst(
                .in0(level4_out[i*2]),
                .in1(level4_out[i*2+1]),
                .sel(sel[4]),
                .out(level5_out[i])
            );
        end
    endgenerate

    generate
        for (i = 0; i < NUM_INPUT_BITS/64; i++) begin
            mux2to1 mux2to1_inst(
                .in0(level5_out[i*2]),
                .in1(level5_out[i*2+1]),
                .sel(sel[5]),
                .out(level6_out[i])
            );
        end
    endgenerate

    generate
        for (i = 0; i < NUM_INPUT_BITS/128; i++) begin
            mux2to1 mux2to1_inst(
                .in0(level6_out[i*2]),
                .in1(level6_out[i*2+1]),
                .sel(sel[6]),
                .out(level7_out[i])
            );
        end
    endgenerate

    // Final selection
    mux2to1 mux2to1_inst(
        .in0(level7_out[0]),
        .in1(level7_out[1]),
        .sel(sel[7]),
        .out(out)
    );

endmodule

// Define a module for the 2-to-1 multiplexer
module mux2to1(
    input in0,
    input in1,
    input sel,
    output out
);

    assign out = sel ? in1 : in0;

endmodule