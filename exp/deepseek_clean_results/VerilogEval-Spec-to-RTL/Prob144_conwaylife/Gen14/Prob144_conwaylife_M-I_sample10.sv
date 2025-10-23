module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Pre-compute row offsets for efficient addressing
    wire [3:0] row_prev [15:0];
    wire [3:0] row_next [15:0];
    wire [3:0] col_prev [15:0];
    wire [3:0] col_next [15:0];
    
    generate
        for (genvar i = 0; i < 16; i = i + 1) begin
            assign row_prev[i] = (i-1) & 15;
            assign row_next[i] = (i+1) & 15;
        end
        for (genvar j = 0; j < 16; j = j + 1) begin
            assign col_prev[j] = (j-1) & 15;
            assign col_next[j] = (j+1) & 15;
        end
    endgenerate

    // Stage 1: Compute neighbor sums for each row
    reg [3:0] row_sums [15:0][15:0];
    wire [15:0] row_active;
    
    generate
        for (genvar i = 0; i < 16; i = i + 1) begin : row_stage
            for (genvar j = 0; j < 16; j = j + 1) begin : col_stage
                always @(posedge clk) begin
                    // Compute sum of 3 neighbors in previous row
                    row_sums[i][j][2:0] <= q[row_prev[i]*16 + col_prev[j]] + 
                                          q[row_prev[i]*16 + j] + 
                                          q[row_prev[i]*16 + col_next[j]];
                    // Store current cell state in MSB
                    row_sums[i][j][3] <= q[i*16 + j];
                end
            end
            // Row activity detection
            assign row_active[i] = (|(q[i*16 +: 16] ^ next_state[i*16 +: 16]));
        end
    endgenerate

    // Stage 2: Final neighbor count and next state calculation
    wire [255:0] next_state;
    reg [255:0] gated_q;
    
    generate
        for (genvar i = 0; i < 16; i = i + 1) begin : row_logic
            for (genvar j = 0; j < 16; j = j + 1) begin : col_logic
                // Registered neighbor counts
                reg [3:0] neighbor_count;
                always @(posedge clk) begin
                    neighbor_count <= row_sums[i][j][2:0] + 
                                     q[i*16 + col_prev[j]] + 
                                     q[i*16 + col_next[j]] + 
                                     row_sums[row_next[i]][j][2:0];
                end
                
                // Next state logic
                assign next_state[i*16+j] = (neighbor_count == 3) || 
                                          ((neighbor_count == 2) && row_sums[i][j][3]);
            end
        end
    endgenerate

    // Clock gating and sequential update
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            for (integer i = 0; i < 16; i = i + 1) begin
                if (row_active[i]) begin
                    q[i*16 +: 16] <= next_state[i*16 +: 16];
                end
            end
        end
    end

endmodule