module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

// Level 1: 16:1 multiplexers
wire [3:0] level1_out [15:0];
genvar i;
for (i = 0; i < 16; i++) begin
    wire [3:0] inputs [15:0];
    for (genvar j = 0; j < 16; j++) begin
        assign inputs[j] = in[(i * 64) + (j * 4) +: 4];
    end
    mux16to1 u_mux16to1 (
        .in(inputs),
        .sel(sel[3:0]),
        .out(level1_out[i])
    );
end

// Level 2: 16:1 multiplexers
wire [3:0] level2_out [3:0];
for (i = 0; i < 4; i++) begin
    wire [3:0] inputs [15:0];
    for (genvar j = 0; j < 16; j++) begin
        assign inputs[j] = level1_out[(i * 4) + j];
    end
    mux16to1 u_mux16to1 (
        .in(inputs),
        .sel(sel[3:0]),
        .out(level2_out[i])
    );
end

// Level 3: 4:1 multiplexers
wire [3:0] level3_out [1:0];
for (i = 0; i < 2; i++) begin
    wire [3:0] inputs [3:0];
    for (genvar j = 0; j < 4; j++) begin
        assign inputs[j] = level2_out[(i * 2) + j];
    end
    mux4to1 u_mux4to1 (
        .in(inputs),
        .sel(sel[1:0]),
        .out(level3_out[i])
    );
end

// Level 4: 2:1 multiplexers
wire [3:0] level4_out;
wire [3:0] inputs [1:0];
assign inputs[0] = level3_out[0];
assign inputs[1] = level3_out[1];
mux2to1 u_mux2to1 (
    .in(inputs),
    .sel(sel[0]),
    .out(level4_out)
);

assign out = level4_out;

endmodule

module mux16to1(
    input  [3:0] in [15:0],
    input  [3:0] sel,
    output [3:0] out
);
    assign out = in[sel];
endmodule

module mux4to1(
    input  [3:0] in [3:0],
    input  [1:0] sel,
    output [3:0] out
);
    assign out = in[sel];
endmodule

module mux2to1(
    input  [3:0] in [1:0],
    input  [0:0] sel,
    output [3:0] out
);
    assign out = in[sel];
endmodule