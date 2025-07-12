module barrel_shifter(
    input   [7:0] in,       // 8-bit input to be shifted
    input   [2:0] ctrl,     // 3-bit control signal
    output  [7:0] out       // 8-bit shifted output
);

// Submodule for a 2-to-1 multiplexer
module mux2X1(
    input   [7:0] in0,  // First input
    input   [7:0] in1,  // Second input
    input         sel,  // Select signal
    output  [7:0] out   // Output
);
    assign out = sel? in1 : in0;
endmodule

// Generate the shifted inputs for each stage
wire [7:0] shifted_by_4;
assign shifted_by_4 = {in[3:0], 4'd0};

wire [7:0] shifted_by_2;
assign shifted_by_2 = {in[5:0], 2'd0};

wire [7:0] shifted_by_1;
assign shifted_by_1 = {in[6:0], 1'd0};

// Stage 1: Shift by 4 positions if ctrl[2] is high
wire [7:0] stage1_out;
mux2X1 stage1_mux(in, shifted_by_4, ctrl[2], stage1_out);

// Stage 2: Shift by 2 positions if ctrl[1] is high
wire [7:0] stage2_out;
mux2X1 stage2_mux(stage1_out, shifted_by_2, ctrl[1], stage2_out);

// Stage 3: Shift by 1 position if ctrl[0] is high
mux2X1 stage3_mux(stage2_out, shifted_by_1, ctrl[0], out);

endmodule