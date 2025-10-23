module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Pipeline stage registers
reg [63:0] adda_reg [3:0];
reg [63:0] addb_reg [3:0];
reg [15:0] g_reg [3:0];  // Generate signals
reg [15:0] p_reg [3:0];  // Propagate signals
reg [3:0] carry_in_reg;   // Stage carry inputs
reg [3:0] en_reg;        // Enable pipeline

// Intermediate wires for prefix computation
wire [15:0] g_stage [3:0];
wire [15:0] p_stage [3:0];
wire [15:0] carry_out [3:0];

// Generate prefix computation for each stage
generate
    for (genvar stage = 0; stage < 4; stage = stage + 1) begin : prefix_stages
        // Compute generate and propagate for each bit
        assign g_stage[stage] = adda_reg[stage][16*stage +: 16] & addb_reg[stage][16*stage +: 16];
        assign p_stage[stage] = adda_reg[stage][16*stage +: 16] ^ addb_reg[stage][16*stage +: 16];
        
        // Kogge-Stone parallel prefix computation
        for (genvar i = 0; i < 16; i = i + 1) begin : prefix
            // First level
            wire g1, p1;
            if (i >= 1) begin
                assign g1 = g_stage[stage][i] | (p_stage[stage][i] & g_stage[stage][i-1]);
                assign p1 = p_stage[stage][i] & p_stage[stage][i-1];
            end else begin
                assign g1 = g_stage[stage][i];
                assign p1 = p_stage[stage][i];
            end
            
            // Second level
            wire g2, p2;
            if (i >= 2) begin
                assign g2 = g1 | (p1 & (i >= 3 ? g_stage[stage][i-2] : g_stage[stage][i-1]));
                assign p2 = p1 & (i >= 3 ? p_stage[stage][i-2] : p_stage[stage][i-1]);
            end else begin
                assign g2 = g1;
                assign p2 = p1;
            end
            
            // Fourth level (skipping 3 for 16-bit)
            wire g4, p4;
            if (i >= 4) begin
                assign g4 = g2 | (p2 & (i >= 8 ? g_stage[stage][i-4] : g_stage[stage][i-2]));
                assign p4 = p2 & (i >= 8 ? p_stage[stage][i-4] : p_stage[stage][i-2]);
            end else begin
                assign g4 = g2;
                assign p4 = p2;
            end
            
            // Eighth level
            wire g8, p8;
            if (i >= 8) begin
                assign g8 = g4 | (p4 & g_stage[stage][i-8]);
                assign p8 = p4 & p_stage[stage][i-8];
            end else begin
                assign g8 = g4;
                assign p8 = p4;
            end
            
            // Carry out computation
            assign carry_out[stage][i] = (i == 15) ? (g8 | (p8 & carry_in_reg[stage])) : 1'b0;
        end
    end
endgenerate

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all pipeline registers
        for (integer i = 0; i < 4; i = i + 1) begin
            adda_reg[i] <= 64'b0;
            addb_reg[i] <= 64'b0;
            g_reg[i] <= 16'b0;
            p_reg[i] <= 16'b0;
            en_reg[i] <= 1'b0;
        end
        carry_in_reg <= 4'b0;
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        // Pipeline stage 0: Input registration
        adda_reg[0] <= adda;
        addb_reg[0] <= addb;
        carry_in_reg[0] <= 1'b0;  // Initial carry-in
        en_reg[0] <= i_en;
        
        // Pipeline stages 1-3
        for (integer stage = 1; stage < 4; stage = stage + 1) begin
            adda_reg[stage] <= adda_reg[stage-1];
            addb_reg[stage] <= addb_reg[stage-1];
            
            // Carry skip between stages
            carry_in_reg[stage] <= |(g_reg[stage-1] & {16{carry_in_reg[stage-1]}});
            
            // Store generate/propagate signals
            g_reg[stage-1] <= g_stage[stage-1];
            p_reg[stage-1] <= p_stage[stage-1];
            
            // Pipeline enable
            en_reg[stage] <= en_reg[stage-1];
        end
        
        // Final sum computation
        result <= {carry_out[3][15], 
                  (adda_reg[3][63:48] ^ addb_reg[3][63:48] ^ {carry_out[3][14:0], carry_in_reg[3]}),
                  (adda_reg[2][47:32] ^ addb_reg[2][47:32] ^ {carry_out[2][14:0], carry_in_reg[2]}),
                  (adda_reg[1][31:16] ^ addb_reg[1][31:16] ^ {carry_out[1][14:0], carry_in_reg[1]}),
                  (adda_reg[0][15:0] ^ addb_reg[0][15:0] ^ {carry_out[0][14:0], carry_in_reg[0]})};
        
        // Output enable synchronized with final stage
        o_en <= en_reg[3];
    end
end

endmodule