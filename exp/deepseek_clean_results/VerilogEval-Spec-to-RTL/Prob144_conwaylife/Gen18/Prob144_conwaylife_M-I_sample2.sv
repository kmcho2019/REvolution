module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Pipeline registers
    reg [255:0] q_ff;
    reg [255:0] next_state;
    reg [255:0] stable_mask;
    
    // Precompute row offsets for faster addressing
    wire [63:0] row_offsets;
    genvar r;
    generate
        for (r = 0; r < 16; r = r + 1) begin : row_off
            assign row_offsets[r*4 +: 4] = r * 16;
        end
    endgenerate

    // Stage 1: Neighbor counting
    integer i, j;
    always @(*) begin
        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                // Compute neighbor rows with wrap-around
                wire [3:0] row_p = (i == 0) ? 15 : (i - 1);
                wire [3:0] row_n = (i == 15) ? 0 : (i + 1);
                
                // Compute neighbor columns with wrap-around
                wire [3:0] col_p = (j == 0) ? 15 : (j - 1);
                wire [3:0] col_n = (j == 15) ? 0 : (j + 1);
                
                // Get neighbor cells (8 total)
                wire nw = q[row_offsets[row_p*4 +: 4] + col_p];
                wire n  = q[row_offsets[row_p*4 +: 4] + j];
                wire ne = q[row_offsets[row_p*4 +: 4] + col_n];
                wire w  = q[row_offsets[i*4 +: 4] + col_p];
                wire e  = q[row_offsets[i*4 +: 4] + col_n];
                wire sw = q[row_offsets[row_n*4 +: 4] + col_p];
                wire s  = q[row_offsets[row_n*4 +: 4] + j];
                wire se = q[row_offsets[row_n*4 +: 4] + col_n];
                
                // Carry-save addition for neighbor count
                wire [1:0] sum1 = nw + n + ne;
                wire [1:0] sum2 = w + e;
                wire [1:0] sum3 = sw + s + se;
                wire [3:0] count = sum1 + sum2 + sum3;
                
                // Compute next state
                wire current = q[row_offsets[i*4 +: 4] + j];
                wire stable = (count == 2) & current;
                wire birth = (count == 3);
                next_state[row_offsets[i*4 +: 4] + j] = stable ? current : birth;
                stable_mask[row_offsets[i*4 +: 4] + j] = (next_state[row_offsets[i*4 +: 4] + j] == current);
            end
        end
    end

    // Stage 2: Clock-gated update
    always @(posedge clk) begin
        q_ff <= q;  // Pipeline register
        
        if (load) begin
            q <= data;
        end else begin
            for (integer k = 0; k < 256; k = k + 1) begin
                // Clock gating based on stability
                if (!stable_mask[k]) begin
                    q[k] <= next_state[k];
                end
            end
        end
    end

endmodule