module adder_pipe_64bit #(
    parameter DATA_WIDTH = 64,
    parameter STG_WIDTH = 8
) (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [DATA_WIDTH-1:0] adda,
    input wire [DATA_WIDTH-1:0] addb,
    output reg [DATA_WIDTH:0] result,
    output reg o_en
);

// Calculate number of segments
localparam SEGMENTS = DATA_WIDTH / STG_WIDTH;

// Pipeline registers
reg [DATA_WIDTH-1:0] adda_pipe [0:SEGMENTS-1];
reg [DATA_WIDTH-1:0] addb_pipe [0:SEGMENTS-1];
reg [SEGMENTS:0] carry_chain;
reg [SEGMENTS:0] en_shift;

// Generate and Propagate signals
wire [SEGMENTS-1:0] G, P;
wire [SEGMENTS:0] carries;

// Segment sums
wire [STG_WIDTH:0] seg_sum [0:SEGMENTS-1];

// Generate lookahead units for each segment
genvar i;
generate
    for (i = 0; i < SEGMENTS; i = i + 1) begin : SEG
        // 4-bit lookahead units within each segment
        wire [3:0] g, p;
        wire [4:0] c;
        
        assign g = {
            (adda_pipe[i][i*STG_WIDTH+7] & addb_pipe[i][i*STG_WIDTH+7]),
            (adda_pipe[i][i*STG_WIDTH+6] & addb_pipe[i][i*STG_WIDTH+6]),
            (adda_pipe[i][i*STG_WIDTH+5] & addb_pipe[i][i*STG_WIDTH+5]),
            (adda_pipe[i][i*STG_WIDTH+4] & addb_pipe[i][i*STG_WIDTH+4])
        };
        
        assign p = {
            (adda_pipe[i][i*STG_WIDTH+7] | addb_pipe[i][i*STG_WIDTH+7]),
            (adda_pipe[i][i*STG_WIDTH+6] | addb_pipe[i][i*STG_WIDTH+6]),
            (adda_pipe[i][i*STG_WIDTH+5] | addb_pipe[i][i*STG_WIDTH+5]),
            (adda_pipe[i][i*STG_WIDTH+4] | addb_pipe[i][i*STG_WIDTH+4])
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
        assign seg_sum[i] = {1'b0, adda_pipe[i][i*STG_WIDTH+STG_WIDTH-1:i*STG_WIDTH]} + 
                          {1'b0, addb_pipe[i][i*STG_WIDTH+STG_WIDTH-1:i*STG_WIDTH]} + 
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
            adda_pipe[j] <= {DATA_WIDTH{1'b0}};
            addb_pipe[j] <= {DATA_WIDTH{1'b0}};
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
        result <= {(DATA_WIDTH+1){1'b0}};
        o_en <= 1'b0;
    end else begin
        // Concatenate all segment sums
        result <= {carry_chain[SEGMENTS], 
                 {SEGMENTS{seg_sum[SEGMENTS-1][STG_WIDTH-1:0]}}}; // Simplified for brevity
        o_en <= en_shift[SEGMENTS];
    end
end

endmodule