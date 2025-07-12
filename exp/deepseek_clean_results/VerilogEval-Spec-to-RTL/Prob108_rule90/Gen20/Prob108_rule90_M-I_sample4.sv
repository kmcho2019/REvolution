module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

parameter WIDTH = 512;
parameter CHUNK_SIZE = 256; // Pipeline stage size

// Pipeline registers
reg [CHUNK_SIZE-1:0] stage1_q;
reg [CHUNK_SIZE-1:0] stage2_q;

// Next state computation - split into two stages
wire [CHUNK_SIZE-1:0] next_stage1;
wire [CHUNK_SIZE-1:0] next_stage2;

// Clock gating logic
wire update_en = ~load;
reg gated_clk;
always @(posedge clk) begin
    gated_clk <= clk & update_en;
end

// Stage 1 computation (bits 0-255)
genvar i;
generate
    for (i = 0; i < CHUNK_SIZE; i = i + 1) begin: stage1
        wire left = (i == 0) ? 1'b0 : q[i-1];
        wire right = q[i+1];
        assign next_stage1[i] = left ^ right;
    end
endgenerate

// Stage 2 computation (bits 256-511)
generate
    for (i = CHUNK_SIZE; i < WIDTH; i = i + 1) begin: stage2
        wire left = q[i-1];
        wire right = (i == WIDTH-1) ? 1'b0 : q[i+1];
        assign next_stage2[i-CHUNK_SIZE] = left ^ right;
    end
endgenerate

// Pipeline stage 1
always @(posedge clk) begin
    if (load) begin
        stage1_q <= data[CHUNK_SIZE-1:0];
    end else begin
        stage1_q <= next_stage1;
    end
end

// Pipeline stage 2 (gated clock)
always @(posedge gated_clk) begin
    stage2_q <= next_stage2;
end

// Final output
always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        q <= {stage2_q, stage1_q};
    end
end

endmodule