module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Parameters
localparam SEGMENTS = 8;
localparam SEG_WIDTH = 8;

// Pipeline registers
reg [63:0] adda_pipe [0:SEGMENTS-1];
reg [63:0] addb_pipe [0:SEGMENTS-1];
reg [SEGMENTS:0] carry_chain;
reg [SEGMENTS:0] en_shift;

// Generate and Propagate signals
wire [SEGMENTS-1:0] G, P;
wire [SEGMENTS:0] carries;

// Segment sums
wire [SEG_WIDTH:0] seg_sum [0:SEGMENTS-1];

// Generate lookahead units for each segment
genvar i;
generate
    for (i = 0; i < SEGMENTS; i = i + 1) begin : SEG
        // 4-bit lookahead units within each 8-bit segment
        wire [3:0] g, p;
        wire [4:0] c;
        
        assign g = {
            (adda_pipe[i][i*8+7] & addb_pipe[i][i*8+7]),
            (adda_pipe[i][i*8+6] & addb_pipe[i][i*8+6]),
            (adda_pipe[i][i*8+5] & addb_pipe[i][i*8+5]),
            (adda_pipe[i][i*8+4] & addb_pipe[i][i*8+4])
        };
        
        assign p = {
            (adda_pipe[i][i*8+7] | addb_pipe[i][i*8+7]),
            (adda_pipe[i][i*8+6] | addb_pipe[i][i*8+6]),
            (adda_pipe[i][i*8+5] | addb_pipe[i][i*8+5]),
            (adda_pipe[i][i*8+4] | addb_pipe[i][i*8+4])
        };
        
        // Carry lookahead logic
        assign c[0] = carry_chain[i];
        assign c[1] = g[0] | (p[0] & c[0]);
        assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c[0]);
        assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | 
                     (p[2] & p[1] & p[0] & c[0]);
        assign c[4] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | 
                     (p[3] & p[2] & p[1] & g[0]) | (p[3] & p[2] & p[1] & p[0] & c[0]);
        
        // Compute segment sum
        assign seg_sum[i] = {1'b0, adda_pipe[i][i*8+7:i*8]} + 
                           {1'b0, addb_pipe[i][i*8+7:i*8]} + 
                           c[4];
        
        // Global propagate/generate
        assign G[i] = &g;
        assign P[i] = &p;
    end
endgenerate

// Carry ripple between segments
assign carries[0] = 1'b0;
generate
    for (i = 1; i <= SEGMENTS; i = i + 1) begin : CARRY
        assign carries[i] = G[i-1] | (P[i-1] & carries[i-1]);
    end
endgenerate

// Pipeline stages
integer j;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (j = 0; j < SEGMENTS; j = j + 1) begin
            adda_pipe[j] <= 64'b0;
            addb_pipe[j] <= 64'b0;
        end
        carry_chain <= {(SEGMENTS+1){1'b0}};
        en_shift <= {(SEGMENTS+1){1'b0}};
    end else begin
        // First stage
        adda_pipe[0] <= adda;
        addb_pipe[0] <= addb;
        carry_chain[0] <= 1'b0;
        en_shift[0] <= i_en;
        
        // Subsequent stages
        for (j = 1; j < SEGMENTS; j = j + 1) begin
            adda_pipe[j] <= adda_pipe[j-1];
            addb_pipe[j] <= addb_pipe[j-1];
            carry_chain[j] <= carries[j];
            en_shift[j] <= en_shift[j-1];
        end
        
        // Final carry
        carry_chain[SEGMENTS] <= carries[SEGMENTS];
        en_shift[SEGMENTS] <= en_shift[SEGMENTS-1];
    end
end

// Output assembly
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        result <= {
            carry_chain[SEGMENTS],
            seg_sum[7][SEG_WIDTH-1:0],
            seg_sum[6][SEG_WIDTH-1:0],
            seg_sum[5][SEG_WIDTH-1:0],
            seg_sum[4][SEG_WIDTH-1:0],
            seg_sum[3][SEG_WIDTH-1:0],
            seg_sum[2][SEG_WIDTH-1:0],
            seg_sum[1][SEG_WIDTH-1:0],
            seg_sum[0][SEG_WIDTH-1:0]
        };
        o_en <= en_shift[SEGMENTS];
    end
end

endmodule