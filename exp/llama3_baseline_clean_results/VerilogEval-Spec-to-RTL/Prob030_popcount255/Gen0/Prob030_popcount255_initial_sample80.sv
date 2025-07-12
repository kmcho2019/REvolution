module TopModule(
    input  [254:0] in,
    output [7:0] out
);

// Initialize the output
reg [7:0] out;

// Stage 1: Reduce 255 bits to 128 bits
wire [127:0] stage1;
genvar i;
for (i = 0; i < 128; i = i + 1) begin
    assign stage1[i] = in[2*i] + in[2*i+1];
end

// Stage 2: Reduce 128 bits to 64 bits
wire [63:0] stage2;
for (i = 0; i < 64; i = i + 1) begin
    assign stage2[i] = stage1[2*i] + stage1[2*i+1];
end

// Stage 3: Reduce 64 bits to 32 bits
wire [31:0] stage3;
for (i = 0; i < 32; i = i + 1) begin
    assign stage3[i] = stage2[2*i] + stage2[2*i+1];
end

// Stage 4: Reduce 32 bits to 16 bits
wire [15:0] stage4;
for (i = 0; i < 16; i = i + 1) begin
    assign stage4[i] = stage3[2*i] + stage3[2*i+1];
end

// Stage 5: Reduce 16 bits to 8 bits
wire [7:0] stage5;
for (i = 0; i < 8; i = i + 1) begin
    assign stage5[i] = stage4[2*i] + stage4[2*i+1];
end

// Final stage: Assign the output
always @(*) begin
    out = stage5;
end

endmodule