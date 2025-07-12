module barrel_shifter(
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);

// Define a 2-to-1 multiplexer module
module mux2X1(
    input [7:0] in0,
    input [7:0] in1,
    input sel,
    output [7:0] out
);
    assign out = sel ? in1 : in0;
endmodule

// Shift input by 1 position
wire [7:0] shift1;
assign shift1 = {in[6:0], in[7]};

// Shift input by 2 positions
wire [7:0] shift2;
assign shift2 = {in[5:0], in[7:6]};

// Shift input by 4 positions
wire [7:0] shift4;
assign shift4 = {in[3:0], in[7:4]};

// First stage: Shift by 4 positions if ctrl[2] is high
wire [7:0] stage1_out;
mux2X1 stage1mux(in, shift4, ctrl[2], stage1_out);

// Second stage: Shift by 2 positions if ctrl[1] is high
wire [7:0] stage2_out;
mux2X1 stage2mux(stage1_out, {stage1_out[5:0], stage1_out[7:6]}, ctrl[1], stage2_out);

// Third stage: Shift by 1 position if ctrl[0] is high
mux2X1 stage3mux(stage2_out, {stage2_out[6:0], stage2_out[7]}, ctrl[0], out);

endmodule