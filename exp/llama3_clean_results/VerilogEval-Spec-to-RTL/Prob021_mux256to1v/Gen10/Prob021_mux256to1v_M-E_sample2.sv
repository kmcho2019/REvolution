module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

// Level 1: 128 2-to-1 multiplexers
wire [3:0] level1_out [127:0];
genvar i;
for (i = 0; i < 128; i++) begin
    assign level1_out[i] = (sel[0] == 0)? in[(i * 8) +: 4] : in[(i * 8) + 4 +: 4];
end

// Level 2: 64 2-to-1 multiplexers
wire [3:0] level2_out [63:0];
for (i = 0; i < 64; i++) begin
    assign level2_out[i] = (sel[1] == 0)? level1_out[i * 2] : level1_out[i * 2 + 1];
end

// Level 3: 32 2-to-1 multiplexers
wire [3:0] level3_out [31:0];
for (i = 0; i < 32; i++) begin
    assign level3_out[i] = (sel[2] == 0)? level2_out[i * 2] : level2_out[i * 2 + 1];
end

// Level 4: 16 2-to-1 multiplexers
wire [3:0] level4_out [15:0];
for (i = 0; i < 16; i++) begin
    assign level4_out[i] = (sel[3] == 0)? level3_out[i * 2] : level3_out[i * 2 + 1];
end

// Level 5: 8 2-to-1 multiplexers
wire [3:0] level5_out [7:0];
for (i = 0; i < 8; i++) begin
    assign level5_out[i] = (sel[4] == 0)? level4_out[i * 2] : level4_out[i * 2 + 1];
end

// Level 6: 4 2-to-1 multiplexers
wire [3:0] level6_out [3:0];
for (i = 0; i < 4; i++) begin
    assign level6_out[i] = (sel[5] == 0)? level5_out[i * 2] : level5_out[i * 2 + 1];
end

// Level 7: 2 2-to-1 multiplexers
wire [3:0] level7_out [1:0];
for (i = 0; i < 2; i++) begin
    assign level7_out[i] = (sel[6] == 0)? level6_out[i * 2] : level6_out[i * 2 + 1];
end

// Final level: 1 2-to-1 multiplexer
assign out = (sel[7] == 0)? level7_out[0] : level7_out[1];

endmodule