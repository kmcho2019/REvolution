// Define the mux2X1 submodule
module mux2X1(
    input  [7:0]  a,  // First input
    input  [7:0]  b,  // Second input
    input         sel,  // Select signal
    output [7:0]  out  // Output
);
    assign out = (sel)? b : a;
endmodule

// Define the barrel_shifter module
module barrel_shifter(
    input  [7:0]  in,  // 8-bit input
    input  [2:0]  ctrl,  // 3-bit control signal
    output [7:0]  out  // 8-bit shifted output
);

    // Stage 1: Shift by 4 positions if ctrl[2] is high
    wire [7:0]  stage1_out;
    mux2X1 stage1_mux(
       .a(in),  // Original input
       .b({in[3:0], 4'b0000}),  // Input shifted by 4 positions
       .sel(ctrl[2]),
       .out(stage1_out)
    );

    // Stage 2: Shift by 2 positions if ctrl[1] is high
    wire [7:0]  stage2_out;
    mux2X1 stage2_mux(
       .a(stage1_out),  // Output from Stage 1
       .b({stage1_out[5:0], 2'b00}),  // Output from Stage 1 shifted by 2 positions
       .sel(ctrl[1]),
       .out(stage2_out)
    );

    // Stage 3: Shift by 1 position if ctrl[0] is high
    wire [7:0]  stage3_out;
    mux2X1 stage3_mux(
       .a(stage2_out),  // Output from Stage 2
       .b({stage2_out[6:0], 1'b0}),  // Output from Stage 2 shifted by 1 position
       .sel(ctrl[0]),
       .out(stage3_out)
    );

    // Assign the final output
    assign out = stage3_out;

endmodule