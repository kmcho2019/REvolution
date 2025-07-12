module mux2X1 #(parameter WIDTH = 8)
    (input  [WIDTH-1:0] in0, in1,
     input             sel,
     output [WIDTH-1:0] out);

    assign out = (sel) ? in1 : in0;
endmodule

module barrel_shifter
    (input  [7:0] in,
     input  [2:0] ctrl,
     output [7:0] out);

    wire [7:0] stage1_out, stage2_out;

    // Stage 1: Shift by 4 positions if ctrl[2] is high
    mux2X1 #(.WIDTH(8)) stage1_mux(
        .in0(in),
        .in1({in[3:0], 4'd0}), // Shift input by 4 positions to the right
        .sel(ctrl[2]),
        .out(stage1_out)
    );

    // Stage 2: Shift by 2 positions if ctrl[1] is high
    mux2X1 #(.WIDTH(8)) stage2_mux(
        .in0(stage1_out),
        .in1({stage1_out[5:0], 2'd0}), // Shift stage1_out by 2 positions to the right
        .sel(ctrl[1]),
        .out(stage2_out)
    );

    // Stage 3: Shift by 1 position if ctrl[0] is high
    mux2X1 #(.WIDTH(8)) stage3_mux(
        .in0(stage2_out),
        .in1({stage2_out[6:0], 1'd0}), // Shift stage2_out by 1 position to the right
        .sel(ctrl[0]),
        .out(out)
    );
endmodule