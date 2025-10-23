module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
);

reg [255:0] q_reg;
reg [255:0] q_next;

// Initialize the game state with the load signal
always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        q_reg <= q_next;
    end
end

// Count the number of neighbors for each cell
genvar i;
generate
    for (i = 0; i < 256; i++) begin : neighbor_count
        reg [3:0] neighbor_count_reg;
        reg [3:0] neighbor_count_next;
        
        // Calculate the row and column indices
        wire [3:0] row_idx = i / 16;
        wire [3:0] col_idx = i % 16;
        
        // Calculate the indices of the neighbors
        wire [3:0] neighbor_idx_nw = (row_idx - 1 + 16) % 16 * 16 + (col_idx - 1 + 16) % 16;
        wire [3:0] neighbor_idx_n = (row_idx - 1 + 16) % 16 * 16 + col_idx;
        wire [3:0] neighbor_idx_ne = (row_idx - 1 + 16) % 16 * 16 + (col_idx + 1) % 16;
        wire [3:0] neighbor_idx_w = row_idx * 16 + (col_idx - 1 + 16) % 16;
        wire [3:0] neighbor_idx_e = row_idx * 16 + (col_idx + 1) % 16;
        wire [3:0] neighbor_idx_sw = (row_idx + 1) % 16 * 16 + (col_idx - 1 + 16) % 16;
        wire [3:0] neighbor_idx_s = (row_idx + 1) % 16 * 16 + col_idx;
        wire [3:0] neighbor_idx_se = (row_idx + 1) % 16 * 16 + (col_idx + 1) % 16;
        
        // Count the number of neighbors
        always @(posedge clk) begin
            neighbor_count_next = q_reg[neighbor_idx_nw] + q_reg[neighbor_idx_n] + q_reg[neighbor_idx_ne] +
                                  q_reg[neighbor_idx_w] + q_reg[neighbor_idx_e] + q_reg[neighbor_idx_sw] +
                                  q_reg[neighbor_idx_s] + q_reg[neighbor_idx_se];
        end
        
        // Update the game state based on the neighbor count
        always @(posedge clk) begin
            if (load) begin
                q_next[i] <= data[i];
            end else begin
                case (neighbor_count_next)
                    0, 1: q_next[i] <= 0;
                    2: q_next[i] <= q_reg[i];
                    3: q_next[i] <= 1;
                    default: q_next[i] <= 0;
                endcase
            end
        end
    end
end

assign q = q_reg;

endmodule