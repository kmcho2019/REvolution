module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);
    // Parameters for block size and count
    localparam BLOCK_SIZE = 64;
    localparam BLOCK_COUNT = 512 / BLOCK_SIZE;

    // Counter to track which block is being updated
    reg [2:0] block_idx;  // 3 bits sufficient for 8 blocks

    // Registers to hold intermediate next state accumulation
    reg [511:0] shadow_q;

    // Extended q for zero padding, for neighborhood lookup
    wire [513:0] ext_q = {1'b0, q, 1'b0};

    // Wires for next state block calculation
    wire [BLOCK_SIZE-1:0] next_block;

    // Rule 110 next state function for a single cell
    function automatic bit rule110_cell(input bit left, input bit center, input bit right);
        rule110_cell = (~left & center) | (center ^ right);
    endfunction

    // Calculate next states for the current block combinationally
    genvar i;
    generate
        for (i = 0; i < BLOCK_SIZE; i = i + 1) begin : next_state_block_gen
            // Global cell index
            localparam int cell_idx = i + BLOCK_SIZE * block_idx;

            wire left   = ext_q[cell_idx + 2];
            wire center = ext_q[cell_idx + 1];
            wire right  = ext_q[cell_idx];
            assign next_block[i] = rule110_cell(left, center, right);
        end
    endgenerate

    always @(posedge clk) begin
        if (load) begin
            // On load, immediately update q and reset block counter & shadow register
            q <= data;
            shadow_q <= data;
            block_idx <= 0;
        end else begin
            // For normal operation, sequentially update one block per cycle
            // Update shadow_q with newly computed block's next states
            shadow_q[BLOCK_SIZE*block_idx +: BLOCK_SIZE] <= next_block;

            if (block_idx == BLOCK_COUNT - 1) begin
                // Last block: commit shadow_q to q and restart counter
                q <= shadow_q;
                block_idx <= 0;
            end else begin
                // Otherwise increment block counter to update next block in next cycle
                block_idx <= block_idx + 1;
            end
        end
    end

endmodule