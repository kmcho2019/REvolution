// mux2X1 submodule
module mux2X1(
    input [7:0] in0,  // first input
    input [7:0] in1,  // second input
    input sel,       // select signal
    output [7:0] out  // output
);
    always @(in0, in1, sel) begin
        if (sel) begin
            out = in1;
        end else begin
            out = in0;
        end
    end
endmodule

// barrel_shifter module
module barrel_shifter(
    input [7:0] in,    // 8-bit input to be shifted
    input [2:0] ctrl,  // 3-bit control signal
    output [7:0] out   // 8-bit shifted output
);

    // Intermediate signals for each stage
    wire [7:0] shift4;
    wire [7:0] shift2;

    // Stage 1: Shift by 4 positions if ctrl[2] is high
    mux2X1 stage1(
        .in0(in),           // original input
        .in1({in[3:0], 4'h0}), // input shifted by 4 positions
        .sel(ctrl[2]),       // select signal
        .out(shift4)         // output of stage 1
    );

    // Stage 2: Shift by 2 positions if ctrl[1] is high
    mux2X1 stage2(
        .in0(shift4),        // input from previous stage
        .in1({shift4[5:0], 2'h0}), // input shifted by 2 positions
        .sel(ctrl[1]),       // select signal
        .out(shift2)         // output of stage 2
    );

    // Stage 3: Shift by 1 position if ctrl[0] is high
    mux2X1 stage3(
        .in0(shift2),        // input from previous stage
        .in1({shift2[6:0], 1'h0}), // input shifted by 1 position
        .sel(ctrl[0]),       // select signal
        .out(out)            // final output
    );

endmodule