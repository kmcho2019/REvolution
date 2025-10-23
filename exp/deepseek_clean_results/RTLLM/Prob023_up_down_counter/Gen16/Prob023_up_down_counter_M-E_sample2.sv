module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

// Internal gray code representation
reg [15:0] gray_count;

// Binary to gray conversion
function [15:0] bin2gray;
    input [15:0] bin;
    bin2gray = bin ^ (bin >> 1);
endfunction

// Gray to binary conversion
function [15:0] gray2bin;
    input [15:0] gray;
    reg [15:0] bin;
    integer i;
    begin
        bin[15] = gray[15];
        for (i = 14; i >= 0; i = i - 1)
            bin[i] = bin[i+1] ^ gray[i];
        gray2bin = bin;
    end
endfunction

// Parallel prefix carry generator
wire [15:0] carry;
wire [15:0] prop, gen;

// Generate propagate and generate terms
assign prop = up_down ? ~gray_count : gray_count;
assign gen = up_down ? gray_count : ~gray_count;

// Kogge-Stone carry network
wire [15:0] prop_stage1, gen_stage1;
wire [15:0] prop_stage2, gen_stage2;
wire [15:0] prop_stage3, gen_stage3;
wire [15:0] prop_stage4, gen_stage4;

// Stage 1 (distance 1)
assign prop_stage1[0] = prop[0];
assign gen_stage1[0] = gen[0];
generate
    genvar i;
    for (i = 1; i < 16; i = i + 1) begin : stage1
        assign prop_stage1[i] = prop[i] & prop[i-1];
        assign gen_stage1[i] = gen[i] | (prop[i] & gen[i-1]);
    end
endgenerate

// Stage 2 (distance 2)
assign prop_stage2[1:0] = prop_stage1[1:0];
assign gen_stage2[1:0] = gen_stage1[1:0];
generate
    for (i = 2; i < 16; i = i + 1) begin : stage2
        assign prop_stage2[i] = prop_stage1[i] & prop_stage1[i-2];
        assign gen_stage2[i] = gen_stage1[i] | (prop_stage1[i] & gen_stage1[i-2]);
    end
endgenerate

// Stage 3 (distance 4)
assign prop_stage3[3:0] = prop_stage2[3:0];
assign gen_stage3[3:0] = gen_stage2[3:0];
generate
    for (i = 4; i < 16; i = i + 1) begin : stage3
        assign prop_stage3[i] = prop_stage2[i] & prop_stage2[i-4];
        assign gen_stage3[i] = gen_stage2[i] | (prop_stage2[i] & gen_stage2[i-4]);
    end
endgenerate

// Stage 4 (distance 8)
assign prop_stage4[7:0] = prop_stage3[7:0];
assign gen_stage4[7:0] = gen_stage3[7:0];
generate
    for (i = 8; i < 16; i = i + 1) begin : stage4
        assign prop_stage4[i] = prop_stage3[i] & prop_stage3[i-8];
        assign gen_stage4[i] = gen_stage3[i] | (prop_stage3[i] & gen_stage3[i-8]);
    end
endgenerate

// Final carry computation
assign carry[0] = up_down; // Carry-in is 1 for increment, 0 for decrement
assign carry[15:1] = gen_stage4[14:0] | (prop_stage4[14:0] & {15{carry[0]}});

// Next gray count computation
wire [15:0] next_gray = gray_count ^ ({carry[14:0], up_down} << 1);

// Boundary condition handling
wire boundary = (up_down & (&gray_count)) | (~up_down & ~(|gray_count));
wire [15:0] next_count = boundary ? {16{up_down}} : gray2bin(next_gray);

always @(posedge clk) begin
    if (reset) begin
        gray_count <= 16'h0000;
        count <= 16'h0000;
    end else begin
        gray_count <= next_gray;
        count <= next_count;
    end
end

endmodule