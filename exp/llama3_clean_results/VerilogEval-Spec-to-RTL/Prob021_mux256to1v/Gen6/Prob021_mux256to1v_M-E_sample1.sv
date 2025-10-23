module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

// First stage: 16 16:1 multiplexers
wire [3:0] stage1_out [15:0];
genvar i;
for (i = 0; i < 16; i++) begin
    wire [15:0][3:0] stage1_in;
    for (genvar j = 0; j < 16; j++) begin
        assign stage1_in[j] = in[(i * 64) + (j * 4) +: 4];
    end
    assign stage1_out[i] = stage1_in[sel[3:0]];
end

// Second stage: 4:1 multiplexer
wire [3:0] stage2_out [3:0];
for (genvar i = 0; i < 4; i++) begin
    wire [3:0][3:0] stage2_in;
    for (genvar j = 0; j < 4; j++) begin
        assign stage2_in[j] = stage1_out[(i * 4) + j];
    end
    assign stage2_out[i] = stage2_in[sel[7:4]];
end

// Final output
assign out = stage2_out[0];

endmodule