// Define the mux2X1 submodule
module mux2X1(
    input [7:0] in0,  // First input
    input [7:0] in1,  // Second input
    input sel,      // Select signal
    output [7:0] out // Output
);
    always @(*) begin
        if (sel) begin
            out = in1;
        end else begin
            out = in0;
        end
    end
endmodule

// Define the barrel_shifter module
module barrel_shifter(
    input [7:0] in,   // 8-bit input to be shifted
    input [2:0] ctrl, // 3-bit control signal
    output [7:0] out   // 8-bit shifted output
);

    // Stage 1: Shift by 4 positions
    wire [7:0] stage1_out;
    mux2X1 stage1_mux(
        .in0(in),
        .in1({in[3:0], 4'b0000}),
        .sel(ctrl[2]),
        .out(stage1_out)
    );

    // Stage 2: Shift by 2 positions
    wire [7:0] stage2_out;
    mux2X1 stage2_mux(
        .in0(stage1_out),
        .in1({stage1_out[5:0], 2'b00}),
        .sel(ctrl[1]),
        .out(stage2_out)
    );

    // Stage 3: Shift by 1 position
    wire [7:0] stage3_out;
    mux2X1 stage3_mux(
        .in0(stage2_out),
        .in1({stage2_out[6:0], 1'b0}),
        .sel(ctrl[0]),
        .out(stage3_out)
    );

    // Output the final result
    assign out = stage3_out;

endmodule