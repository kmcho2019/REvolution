// Define the mux2X1 module
module mux2X1(
    input  wire [7:0] in0,  // First input
    input  wire [7:0] in1,  // Second input
    input  wire        sel,  // Select signal
    output wire [7:0] out   // Output
);
    always @(*) begin
        case (sel)
            1'b0: out = in0;
            1'b1: out = in1;
            default: out = 8'b0;
        endcase
    end
endmodule

// Define the barrel_shifter module
module barrel_shifter(
    input  wire [7:0] in,   // 8-bit input
    input  wire [2:0] ctrl,  // 3-bit control signal
    output wire [7:0] out   // 8-bit shifted output
);
    // Internal signals
    wire [7:0] stage1_out;
    wire [7:0] stage2_out;

    // Stage 1: Shift by 4 positions if ctrl[2] is high
    mux2X1 stage1_mux(
       .in0(in),  // Original input
       .in1({in[3:0], 4'b0}),  // Input shifted by 4 positions
       .sel(ctrl[2]),
       .out(stage1_out)
    );

    // Stage 2: Shift by 2 positions if ctrl[1] is high
    mux2X1 stage2_mux(
       .in0(stage1_out),  // Output from previous stage
       .in1({stage1_out[5:0], 2'b0}),  // Output shifted by 2 positions
       .sel(ctrl[1]),
       .out(stage2_out)
    );

    // Stage 3: Shift by 1 position if ctrl[0] is high
    mux2X1 stage3_mux(
       .in0(stage2_out),  // Output from previous stage
       .in1({stage2_out[6:0], 1'b0}),  // Output shifted by 1 position
       .sel(ctrl[0]),
       .out(out)
    );
endmodule