// Define the 2-to-1 multiplexer submodule
module mux2X1(
    input [7:0] in0, in1,
    input sel,
    output [7:0] out
);
    always @(in0, in1, sel) begin
        if (sel) begin
            out = in1;
        end else begin
            out = in0;
        end
    end
endmodule

// Define the barrel shifter module
module barrel_shifter(
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);
    // Internal wires to hold intermediate results
    wire [7:0] stage1_out, stage2_out;

    // Stage 1: Shift by 4 positions if ctrl[2] is high
    mux2X1 stage1(
        .in0(in),
        .in1({in[3:0], 4'b0000}), // Shift in by 4 positions
        .sel(ctrl[2]),
        .out(stage1_out)
    );

    // Stage 2: Shift by 2 positions if ctrl[1] is high
    mux2X1 stage2(
        .in0(stage1_out),
        .in1({stage1_out[5:0], 2'b00}), // Shift in by 2 positions
        .sel(ctrl[1]),
        .out(stage2_out)
    );

    // Stage 3: Shift by 1 position if ctrl[0] is high
    mux2X1 stage3(
        .in0(stage2_out),
        .in1({stage2_out[6:0], 1'b0}), // Shift in by 1 position
        .sel(ctrl[0]),
        .out(out)
    );
endmodule