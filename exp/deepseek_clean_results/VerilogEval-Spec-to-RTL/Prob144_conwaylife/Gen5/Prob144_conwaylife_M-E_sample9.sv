module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Processing Element (PE) for each row
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : pe_array
            // Neighbor rows (with wrap-around)
            wire [15:0] prev_row = (i == 0) ? q[255:240] : q[i*16-1 -:16];
            wire [15:0] curr_row = q[i*16 +:16];
            wire [15:0] next_row = (i == 15) ? q[15:0] : q[(i+1)*16 +:16];
            
            // Shift registers for neighbor propagation
            reg [15:0] prev_row_sr [2:0];
            reg [15:0] curr_row_sr [2:0];
            reg [15:0] next_row_sr [2:0];
            
            // Pipeline registers for neighbor counts
            reg [3:0] neighbor_count [15:0];
            
            // Processing logic
            integer j;
            always @(posedge clk) begin
                if (load) begin
                    // Load new data
                    curr_row_sr[0] <= data[i*16 +:16];
                end else begin
                    // Stage 1: Shift neighbor rows
                    prev_row_sr[0] <= prev_row;
                    curr_row_sr[0] <= curr_row;
                    next_row_sr[0] <= next_row;
                    
                    // Stage 2: Calculate neighbor counts
                    for (j = 0; j < 16; j = j + 1) begin
                        // Get wrapped column indices
                        integer left = (j == 0) ? 15 : j-1;
                        integer right = (j == 15) ? 0 : j+1;
                        
                        // Count neighbors from all three rows
                        neighbor_count[j] <= 
                            prev_row_sr[0][left] + prev_row_sr[0][j] + prev_row_sr[0][right] +
                            curr_row_sr[0][left] + curr_row_sr[0][right] +
                            next_row_sr[0][left] + next_row_sr[0][j] + next_row_sr[0][right];
                    end
                    
                    // Stage 3: Update cell state
                    for (j = 0; j < 16; j = j + 1) begin
                        case (neighbor_count[j])
                            4'd2: q[i*16 + j] <= q[i*16 + j]; // No change
                            4'd3: q[i*16 + j] <= 1'b1;        // Birth
                            default: q[i*16 + j] <= 1'b0;      // Death
                        endcase
                    end
                end
            end
        end
    endgenerate

endmodule