// Population count module for each segment
module SegmentPopCount(
    input [7:0] in,
    output [7:0] out
);
    assign out = $countones(in);
endmodule

// Adder tree module
module AdderTree(
    input [7:0] in0,
    input [7:0] in1,
    output [8:0] out
);
    assign out = in0 + in1;
endmodule

// Top-level module
module TopModule(
    input [254:0] in,
    output [7:0] out
);
    // Divide the input into 32 segments of 8 bits
    wire [7:0] segment [31:0];

    // Assign the segments
    genvar i;
    for (i = 0; i < 32; i++) begin
        if (i == 31) begin
            assign segment[i] = {1'b0, in[254:248]};
        end else begin
            assign segment[i] = in[(i*8)+7:i*8];
        end
    end

    // Population counts for each segment
    wire [7:0] segment_count [31:0];

    // Assign the population counts
    for (genvar i = 0; i < 32; i++) begin
        SegmentPopCount u_segment_pop_count(
            .in(segment[i]),
            .out(segment_count[i])
        );
    end

    // Adder tree to sum up the population counts
    wire [8:0] adder_tree_out [4:0];

    // Level 1: 16 adders
    for (genvar i = 0; i < 16; i++) begin
        AdderTree u_adder_tree_1(
            .in0(segment_count[i*2]),
            .in1(segment_count[i*2+1]),
            .out(adder_tree_out[i])
        );
    end

    // Level 2: 8 adders
    for (genvar i = 0; i < 8; i++) begin
        AdderTree u_adder_tree_2(
            .in0(adder_tree_out[i*2][7:0]),
            .in1(adder_tree_out[i*2+1][7:0]),
            .out(adder_tree_out[i+16])
        );
    end

    // Level 3: 4 adders
    for (genvar i = 0; i < 4; i++) begin
        AdderTree u_adder_tree_3(
            .in0(adder_tree_out[i*2+16][7:0]),
            .in1(adder_tree_out[i*2+17][7:0]),
            .out(adder_tree_out[i+24])
        );
    end

    // Level 4: 2 adders
    for (genvar i = 0; i < 2; i++) begin
        AdderTree u_adder_tree_4(
            .in0(adder_tree_out[i*2+24][7:0]),
            .in1(adder_tree_out[i*2+25][7:0]),
            .out(adder_tree_out[i+28])
        );
    end

    // Final adder
    AdderTree u_final_adder(
        .in0(adder_tree_out[28][7:0]),
        .in1(adder_tree_out[29][7:0]),
        .out(adder_tree_out[30])
    );

    // Assign the output
    assign out = adder_tree_out[30][7:0];
endmodule