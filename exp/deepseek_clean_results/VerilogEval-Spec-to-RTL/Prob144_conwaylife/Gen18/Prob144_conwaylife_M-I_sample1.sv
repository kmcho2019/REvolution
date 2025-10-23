module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Precompute row offsets for address calculation
    wire [7:0] row_offsets [15:0];
    generate
        for (genvar i = 0; i < 16; i = i + 1) begin
            assign row_offsets[i] = i * 16;
        end
    endgenerate

    wire [255:0] next_state;
    wire [255:0] change_mask;
    
    generate
        for (genvar i = 0; i < 16; i = i + 1) begin : row
            for (genvar j = 0; j < 16; j = j + 1) begin : col
                // Neighbor indices with optimized wrap-around
                localparam [3:0] row_prev = (i-1) & 15;
                localparam [3:0] row_next = (i+1) & 15;
                localparam [3:0] col_prev = (j-1) & 15;
                localparam [3:0] col_next = (j+1) & 15;
                
                // Shared neighbor calculations
                wire nw = q[row_offsets[row_prev] + col_prev];
                wire n  = q[row_offsets[row_prev] + j];
                wire ne = q[row_offsets[row_prev] + col_next];
                wire w  = q[row_offsets[i] + col_prev];
                wire e  = q[row_offsets[i] + col_next];
                wire sw = q[row_offsets[row_next] + col_prev];
                wire s  = q[row_offsets[row_next] + j];
                wire se = q[row_offsets[row_next] + col_next];
                
                // Carry-save neighbor counting (3:2 compressor)
                wire [1:0] sum1 = nw + n + ne;
                wire [1:0] sum2 = w + e;
                wire [1:0] sum3 = sw + s + se;
                
                // Final adder with pipeline register
                reg [3:0] count;
                always @(posedge clk) begin
                    count <= sum1 + sum2 + sum3;
                end
                
                // Next state logic
                reg cell_state;
                always @(posedge clk) begin
                    if (load) begin
                        cell_state <= data[i*16+j];
                    end else begin
                        case (count)
                            2: cell_state <= cell_state;
                            3: cell_state <= 1'b1;
                            default: cell_state <= 1'b0;
                        endcase
                    end
                end
                
                assign next_state[i*16+j] = cell_state;
                assign change_mask[i*16+j] = (load || (next_state[i*16+j] != q[i*16+j]));
            end
        end
    endgenerate

    // Clock-gated update
    always @(posedge clk) begin
        for (integer k = 0; k < 256; k = k + 1) begin
            if (change_mask[k]) begin
                q[k] <= next_state[k];
            end
        end
    end

endmodule