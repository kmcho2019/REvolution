module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Circular shift registers for each row
    reg [15:0] rows [15:0];
    wire [15:0] shifted_up [15:0];
    wire [15:0] shifted_down [15:0];
    wire [15:0] shifted_left [15:0];
    wire [15:0] shifted_right [15:0];

    // Initialize shift registers and connections
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : row_shifters
            // Current row state
            always @(posedge clk) begin
                if (load) begin
                    rows[i] <= data[i*16 +: 16];
                end else begin
                    rows[i] <= q[i*16 +: 16];
                end
            end

            // Circular shifts for neighbor access
            assign shifted_left[i] = {rows[i][0], rows[i][15:1]};  // Left neighbor
            assign shifted_right[i] = {rows[i][14:0], rows[i][15]}; // Right neighbor
            assign shifted_up[i] = (i == 0) ? rows[15] : rows[i-1]; // Top neighbor
            assign shifted_down[i] = (i == 15) ? rows[0] : rows[i+1]; // Bottom neighbor
        end
    endgenerate

    // Next state calculation
    wire [255:0] next_state;
    generate
        for (i = 0; i < 16; i = i + 1) begin : next_state_calc
            for (genvar j = 0; j < 16; j = j + 1) begin : col_calc
                // Neighbor counts
                wire left = shifted_left[i][j];
                wire right = shifted_right[i][j];
                wire top = shifted_up[i][j];
                wire bottom = shifted_down[i][j];
                wire top_left = shifted_up[i][ (j == 0) ? 15 : j-1 ];
                wire top_right = shifted_up[i][ (j == 15) ? 0 : j+1 ];
                wire bottom_left = shifted_down[i][ (j == 0) ? 15 : j-1 ];
                wire bottom_right = shifted_down[i][ (j == 15) ? 0 : j+1 ];

                // Hierarchical neighbor counting
                wire [1:0] same_row = left + right;
                wire [1:0] top_row = top_left + top + top_right;
                wire [1:0] bottom_row = bottom_left + bottom + bottom_right;
                wire [2:0] total_neighbors = same_row + top_row + bottom_row;

                // Game rules implementation
                assign next_state[i*16 + j] = 
                    (total_neighbors == 3) ? 1'b1 :
                    (total_neighbors == 2) ? rows[i][j] :
                    1'b0;
            end
        end
    endgenerate

    // Update state
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_state;
        end
    end

endmodule