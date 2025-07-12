module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

// Define a 2-to-1 multiplexer module
module mux2to1(
    input  [3:0] in0,
    input  [3:0] in1,
    input  sel,
    output [3:0] out
);
    assign out = sel ? in1 : in0;
endmodule

// First stage: 128 2-to-1 multiplexers
wire [3:0] stage1_out [127:0];
genvar i;
for (i = 0; i < 128; i++) begin
    mux2to1 mux2to1_inst(
        .in0(in[i * 8 +: 4]),
        .in1(in[i * 8 + 4 +: 4]),
        .sel(sel[0]),
        .out(stage1_out[i])
    );
end

// Second stage: 64 2-to-1 multiplexers
wire [3:0] stage2_out [63:0];
for (i = 0; i < 64; i++) begin
    mux2to1 mux2to1_inst(
        .in0(stage1_out[i * 2]),
        .in1(stage1_out[i * 2 + 1]),
        .sel(sel[1]),
        .out(stage2_out[i])
    );
end

// Third stage: 32 2-to-1 multiplexers
wire [3:0] stage3_out [31:0];
for (i = 0; i < 32; i++) begin
    mux2to1 mux2to1_inst(
        .in0(stage2_out[i * 2]),
        .in1(stage2_out[i * 2 + 1]),
        .sel(sel[2]),
        .out(stage3_out[i])
    );
end

// Fourth stage: 16 2-to-1 multiplexers
wire [3:0] stage4_out [15:0];
for (i = 0; i < 16; i++) begin
    mux2to1 mux2to1_inst(
        .in0(stage3_out[i * 2]),
        .in1(stage3_out[i * 2 + 1]),
        .sel(sel[3]),
        .out(stage4_out[i])
    );
end

// Final stage: 1 2-to-1 multiplexer
wire [3:0] stage5_out;
mux2to1 mux2to1_inst(
    .in0(stage4_out[sel[7:4] * 2]),
    .in1(stage4_out[sel[7:4] * 2 + 1]),
    .sel(sel[4]),
    .out(stage5_out)
);

assign out = stage5_out;

endmodule