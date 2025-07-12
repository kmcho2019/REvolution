// Define the mux2X1 submodule
module mux2X1 (
    input [7:0] in0,  // First input
    input [7:0] in1,  // Second input
    input sel,      // Select signal
    output [7:0] out // Output
);

    always @(in0, in1, sel) begin
        if (sel) begin
            out = in1;
        end else begin
            out = in0;
        end
    end

endmodule

// Define the barrel_shifter module
module barrel_shifter (
    input [7:0] in,  // 8-bit input to be shifted
    input [2:0] ctrl,  // 3-bit control signal
    output [7:0] out // 8-bit shifted output
);

    // Define the intermediate wires
    wire [7:0] stage1_out;
    wire [7:0] stage2_out;
    wire [7:0] stage3_out;

    // Stage 1: Shift by 4 positions if ctrl[2] is high
    mux2X1 stage1_mux (
        .in0(in),  // Original input
        .in1({in[3:0], 4'b0000}),  // Input shifted by 4 positions
        .sel(ctrl[2]),  // Select signal
        .out(stage1_out)  // Output of stage 1
    );

    // Stage 2: Shift by 2 positions if ctrl[1] is high
    mux2X1 stage2_mux (
        .in0(stage1_out),  // Output of stage 1
        .in1({stage1_out[5:0], 2'b00}),  // Output of stage 1 shifted by 2 positions
        .sel(ctrl[1]),  // Select signal
        .out(stage2_out)  // Output of stage 2
    );

    // Stage 3: Shift by 1 position if ctrl[0] is high
    mux2X1 stage3_mux (
        .in0(stage2_out),  // Output of stage 2
        .in1({stage2_out[6:0], 1'b0}),  // Output of stage 2 shifted by 1 position
        .sel(ctrl[0]),  // Select signal
        .out(stage3_out)  // Output of stage 3
    );

    // Assign the final output
    assign out = stage3_out;

endmodule