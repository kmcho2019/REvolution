module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Shift register banks for neighbor access
    reg [255:0] q_north, q_south, q_east, q_west;
    
    // Stage 1: Neighbor counting
    wire [255:0][3:0] neighbor_counts;
    
    // Stage 2: Next state calculation
    reg [255:0] next_q;
    
    // Shift register update logic
    always @(posedge clk) begin
        if (load) begin
            q <= data;
            q_north <= data;
            q_south <= data;
            q_east <= data;
            q_west <= data;
        end else begin
            // Update shift registers (toroidal wrapping)
            for (integer i = 0; i < 256; i = i + 1) begin
                // North shift (row - 1)
                q_north[i] <= q[((i/16 - 1) & 15) * 16 + (i % 16)];
                // South shift (row + 1)
                q_south[i] <= q[((i/16 + 1) & 15) * 16 + (i % 16)];
                // East shift (col + 1)
                q_east[i] <= q[(i/16) * 16 + ((i % 16) + 1) & 15];
                // West shift (col - 1)
                q_west[i] <= q[(i/16) * 16 + ((i % 16) - 1) & 15];
            end
            
            // Update main register
            q <= next_q;
        end
    end
    
    // Parallel neighbor counting
    genvar i;
    generate
        for (i = 0; i < 256; i = i + 1) begin : neighbor_count
            // Count neighbors from each direction in parallel
            wire [1:0] count_nw = q_north[i] + q_west[i];
            wire [1:0] count_ne = q_north[i] + q_east[i];
            wire [1:0] count_sw = q_south[i] + q_west[i];
            wire [1:0] count_se = q_south[i] + q_east[i];
            
            // Combine counts with center cell's direct neighbors
            wire [3:0] total_count = 
                count_nw + count_ne + count_sw + count_se + 
                q_north[i] + q_south[i] + q_east[i] + q_west[i];
            
            assign neighbor_counts[i] = total_count;
        end
    endgenerate
    
    // Next state calculation (pipelined)
    always @(*) begin
        for (integer j = 0; j < 256; j = j + 1) begin
            case (neighbor_counts[j])
                4'd2: next_q[j] = q[j];    // Maintain state
                4'd3: next_q[j] = 1'b1;    // Birth
                default: next_q[j] = 1'b0;  // Death
            endcase
        end
    end

endmodule