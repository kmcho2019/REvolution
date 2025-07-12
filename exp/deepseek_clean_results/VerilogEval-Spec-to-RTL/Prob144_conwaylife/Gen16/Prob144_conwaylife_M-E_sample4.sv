module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
);

    // Block RAM for game state
    reg [15:0] grid_mem [0:15];
    
    // Current and next state registers
    reg [255:0] current_state;
    reg [255:0] next_state;
    
    // Pipeline registers
    reg [3:0] stage1_block_x, stage1_block_y;
    reg [3:0] stage2_block_x, stage2_block_y;
    
    // Neighbor count registers
    reg [3:0] neighbor_counts [0:15][0:15];
    
    // Address generation unit
    function [3:0] wrap_addr;
        input [3:0] addr;
        begin
            wrap_addr = addr[3:0]; // Automatic 4-bit wrap-around
        end
    endfunction
    
    // Initialize BRAM and registers
    integer i, j;
    initial begin
        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                grid_mem[i][j] = 0;
                neighbor_counts[i][j] = 0;
            end
        end
        current_state = 0;
        next_state = 0;
    end
    
    // Load or update state
    always @(posedge clk) begin
        if (load) begin
            // Load new state into BRAM
            for (i = 0; i < 16; i = i + 1) begin
                grid_mem[i] <= data[i*16 +: 16];
            end
            current_state <= data;
        end else begin
            // Update BRAM with next state
            for (i = 0; i < 16; i = i + 1) begin
                grid_mem[i] <= next_state[i*16 +: 16];
            end
            current_state <= next_state;
        end
    end
    
    // Pipeline stage 1: Intra-block neighbor counting
    always @(posedge clk) begin
        for (i = 0; i < 4; i = i + 1) begin
            for (j = 0; j < 4; j = j + 1) begin
                stage1_block_x <= i;
                stage1_block_y <= j;
                
                // Process each 4x4 block
                for (int bi = 0; bi < 4; bi = bi + 1) begin
                    for (int bj = 0; bj < 4; bj = bj + 1) begin
                        // Calculate absolute coordinates with wrap
                        int x = (i*4 + bi) % 16;
                        int y = (j*4 + bj) % 16;
                        
                        // Count neighbors within current 4x4 block
                        neighbor_counts[x][y] <= 
                            grid_mem[wrap_addr(x-1)][wrap_addr(y-1)] +
                            grid_mem[wrap_addr(x-1)][y] +
                            grid_mem[wrap_addr(x-1)][wrap_addr(y+1)] +
                            grid_mem[x][wrap_addr(y-1)] +
                            grid_mem[x][wrap_addr(y+1)] +
                            grid_mem[wrap_addr(x+1)][wrap_addr(y-1)] +
                            grid_mem[wrap_addr(x+1)][y] +
                            grid_mem[wrap_addr(x+1)][wrap_addr(y+1)];
                    end
                end
            end
        end
    end
    
    // Pipeline stage 2: Inter-block combination and state update
    always @(posedge clk) begin
        for (i = 0; i < 4; i = i + 1) begin
            for (j = 0; j < 4; j = j + 1) begin
                stage2_block_x <= i;
                stage2_block_y <= j;
                
                // Process each cell in the 4x4 block
                for (int bi = 0; bi < 4; bi = bi + 1) begin
                    for (int bj = 0; bj < 4; bj = bj + 1) begin
                        // Calculate absolute coordinates
                        int x = (i*4 + bi) % 16;
                        int y = (j*4 + bj) % 16;
                        
                        // Get current cell state
                        reg current = grid_mem[x][y];
                        
                        // Apply game rules
                        case (neighbor_counts[x][y])
                            0, 1: next_state[x*16 + y] <= 0;
                            2: next_state[x*16 + y] <= current;
                            3: next_state[x*16 + y] <= 1;
                            default: next_state[x*16 + y] <= 0;
                        endcase
                    end
                end
            end
        end
    end
    
    // Output assignment
    assign q = current_state;

endmodule