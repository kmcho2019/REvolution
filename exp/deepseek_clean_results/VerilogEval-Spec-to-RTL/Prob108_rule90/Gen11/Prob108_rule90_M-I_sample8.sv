module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

// Pipeline registers
reg [127:0] stage1_q, stage2_q, stage3_q, stage4_q;
reg stage1_valid, stage2_valid, stage3_valid;

// Clock gating signals
wire clk_en = load | stage1_valid | stage2_valid | stage3_valid;
wire gated_clk = clk & clk_en;

// Stage 1: Process bits 0-127
wire [127:0] stage1_next;
generate
    genvar i;
    for (i = 0; i < 128; i = i + 1) begin: stage1
        wire left = (i == 0) ? 1'b0 : q[i-1];
        wire right = q[i+1];
        assign stage1_next[i] = left ^ right;
    end
endgenerate

// Stage 2: Process bits 128-255
wire [127:0] stage2_next;
generate
    for (i = 0; i < 128; i = i + 1) begin: stage2
        wire left = stage1_q[i];
        wire right = (i == 127) ? q[256] : q[128+i+1];
        assign stage2_next[i] = left ^ right;
    end
endgenerate

// Stage 3: Process bits 256-383
wire [127:0] stage3_next;
generate
    for (i = 0; i < 128; i = i + 1) begin: stage3
        wire left = (i == 0) ? q[255] : stage2_q[i-1];
        wire right = q[256+i+1];
        assign stage3_next[i] = left ^ right;
    end
endgenerate

// Stage 4: Process bits 384-511
wire [127:0] stage4_next;
generate
    for (i = 0; i < 128; i = i + 1) begin: stage4
        wire left = (i == 0) ? q[383] : stage3_q[i-1];
        wire right = (i == 127) ? 1'b0 : q[384+i+1];
        assign stage4_next[i] = left ^ right;
    end
endgenerate

always @(posedge gated_clk) begin
    if (load) begin
        q <= data;
        stage1_valid <= 1'b0;
        stage2_valid <= 1'b0;
        stage3_valid <= 1'b0;
    end else begin
        // Pipeline the computation
        stage1_q <= stage1_next;
        stage2_q <= stage2_next;
        stage3_q <= stage3_next;
        q[127:0] <= stage1_q;
        q[255:128] <= stage2_q;
        q[383:256] <= stage3_q;
        q[511:384] <= stage4_next;
        
        // Pipeline valid signals
        stage1_valid <= 1'b1;
        stage2_valid <= stage1_valid;
        stage3_valid <= stage2_valid;
    end
end

endmodule