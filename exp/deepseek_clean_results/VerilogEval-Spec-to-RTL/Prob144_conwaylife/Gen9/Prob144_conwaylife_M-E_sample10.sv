module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Pipeline registers
    reg [255:0] current_state;
    reg [255:0] neighbor_counts [0:255];
    
    // Circular shift registers for wrapping
    wire [15:0] row_above [0:15];
    wire [15:0] row_below [0:15];
    
    // Precompute neighbor masks (8 neighbors per cell)
    reg [255:0] neighbor_masks [0:7];
    
    // Initialize neighbor masks (done once at synthesis)
    integer i, j, n;
    initial begin
        for (n = 0; n < 8; n = n + 1) begin
            neighbor_masks[n] = 256'b0;
        end
        
        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                // Calculate neighbor positions with wrapping
                integer row_p = (i == 0) ? 15 : i-1;
                integer row_n = (i == 15) ? 0 : i+1;
                integer col_p = (j == 0) ? 15 : j-1;
                integer col_n = (j == 15) ? 0 : j+1;
                
                // Set neighbor mask bits
                neighbor_masks[0][row_p*16 + col_p] = 1'b1; // top-left
                neighbor_masks[1][row_p*16 + j] = 1'b1;     // top
                neighbor_masks[2][row_p*16 + col_n] = 1'b1; // top-right
                neighbor_masks[3][i*16 + col_p] = 1'b1;     // left
                neighbor_masks[4][i*16 + col_n] = 1'b1;     // right
                neighbor_masks[5][row_n*16 + col_p] = 1'b1; // bottom-left
                neighbor_masks[6][row_n*16 + j] = 1'b1;     // bottom
                neighbor_masks[7][row_n*16 + col_n] = 1'b1; // bottom-right
            end
        end
    end

    // Phase 1: Count neighbors (combinational)
    always @(*) begin
        for (i = 0; i < 256; i = i + 1) begin
            reg [3:0] count = 0;
            for (n = 0; n < 8; n = n + 1) begin
                count = count + ((q & neighbor_masks[n]) >> i);
            end
            neighbor_counts[i] = count;
        end
    end

    // Phase 2: Update state (sequential)
    always @(posedge clk) begin
        if (load) begin
            current_state <= data;
        end else begin
            for (i = 0; i < 256; i = i + 1) begin
                case (neighbor_counts[i])
                    4'd0, 4'd1: current_state[i] <= 1'b0;
                    4'd2: current_state[i] <= current_state[i];
                    4'd3: current_state[i] <= 1'b1;
                    default: current_state[i] <= 1'b0;
                endcase
            end
        end
    end

    assign q = current_state;

endmodule