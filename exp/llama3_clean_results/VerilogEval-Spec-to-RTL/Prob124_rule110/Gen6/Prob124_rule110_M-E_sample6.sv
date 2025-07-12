module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] current_state;
reg [511:0] next_state;

// Define the number of blocks
localparam NUM_BLOCKS = 512 / 8;

// Define the Rule 110 lookup table for each block
reg [7:0] rule110_lookup_table[0:255];

// Initialize the lookup table
initial begin
    for (int i = 0; i < 256; i++) begin
        reg [7:0] current_block_state;
        current_block_state = i;
        
        // Compute the next state of the block
        for (int j = 0; j < 8; j++) begin
            reg [2:0] neighbor_values;
            reg left, center, right;
            
            // Handle boundary conditions within the block
            if (j == 0) begin
                left = 1'b0;
            end else begin
                left = current_block_state[j-1];
            end
            if (j == 7) begin
                right = 1'b0;
            end else begin
                right = current_block_state[j+1];
            end
            center = current_block_state[j];
            
            // Pack neighbor values into a 3-bit value
            neighbor_values = {left, center, right};
            
            // Compute the next state of the cell
            case (neighbor_values)
                3'b000: rule110_lookup_table[i][j] = 1'b0;
                3'b001: rule110_lookup_table[i][j] = 1'b1;
                3'b010: rule110_lookup_table[i][j] = 1'b1;
                3'b011: rule110_lookup_table[i][j] = 1'b0;
                3'b100: rule110_lookup_table[i][j] = 1'b1;
                3'b101: rule110_lookup_table[i][j] = 1'b1;
                3'b110: rule110_lookup_table[i][j] = 1'b1;
                3'b111: rule110_lookup_table[i][j] = 1'b0;
                default: rule110_lookup_table[i][j] = 1'b0;
            endcase
        end
    end
end

// Calculate next state using lookup table
always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        for (int i = 0; i < NUM_BLOCKS; i++) begin
            reg [7:0] current_block_state;
            reg [7:0] next_block_state;
            
            // Extract the current block state
            current_block_state = current_state[i*8 +: 8];
            
            // Compute the next state of the block
            next_block_state = rule110_lookup_table[current_block_state];
            
            // Update the next state
            next_state[i*8 +: 8] = next_block_state;
        end
        
        current_state <= next_state;
    end
end

assign q = current_state;

endmodule