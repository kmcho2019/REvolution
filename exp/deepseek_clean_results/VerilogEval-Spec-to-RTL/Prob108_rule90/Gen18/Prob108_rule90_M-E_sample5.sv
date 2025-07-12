module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

parameter WIDTH = 512;
parameter BLOCK_SIZE = 32;
parameter NUM_BLOCKS = WIDTH/BLOCK_SIZE;

// Boundary conditions
wire left_boundary = 1'b0;
wire right_boundary = 1'b0;

// Block interface registers
reg [BLOCK_SIZE-1:0] block_left [NUM_BLOCKS-1:0];
reg [BLOCK_SIZE-1:0] block_right [NUM_BLOCKS-1:0];

// Next state computation
wire [WIDTH-1:0] next_q;

// Block activity detection
wire [NUM_BLOCKS-1:0] block_active;

generate
    genvar block_idx;
    for (block_idx = 0; block_idx < NUM_BLOCKS; block_idx = block_idx + 1) begin: block_processing
        // Block boundary processing
        always @(posedge clk) begin
            if (load) begin
                block_left[block_idx] <= (block_idx == 0) ? {BLOCK_SIZE{left_boundary}} : 
                                       data[block_idx*BLOCK_SIZE-1 -:BLOCK_SIZE];
                block_right[block_idx] <= (block_idx == NUM_BLOCKS-1) ? {BLOCK_SIZE{right_boundary}} : 
                                        data[(block_idx+1)*BLOCK_SIZE +:BLOCK_SIZE];
            end else begin
                block_left[block_idx] <= (block_idx == 0) ? {BLOCK_SIZE{left_boundary}} : 
                                       q[block_idx*BLOCK_SIZE-1 -:BLOCK_SIZE];
                block_right[block_idx] <= (block_idx == NUM_BLOCKS-1) ? {BLOCK_SIZE{right_boundary}} : 
                                        q[(block_idx+1)*BLOCK_SIZE +:BLOCK_SIZE];
            end
        end

        // Activity detection per block
        assign block_active[block_idx] = |q[block_idx*BLOCK_SIZE +:BLOCK_SIZE] || 
                                       |next_q[block_idx*BLOCK_SIZE +:BLOCK_SIZE];

        // Hierarchical XOR computation within block
        genvar cell_idx;
        for (cell_idx = 0; cell_idx < BLOCK_SIZE; cell_idx = cell_idx + 1) begin: cell_processing
            // Stage 1: Internal cells (non-boundary)
            if (cell_idx > 0 && cell_idx < BLOCK_SIZE-1) begin
                assign next_q[block_idx*BLOCK_SIZE + cell_idx] = 
                    q[block_idx*BLOCK_SIZE + cell_idx - 1] ^ 
                    q[block_idx*BLOCK_SIZE + cell_idx + 1];
            end
            // Stage 2: Boundary cells (use registered values)
            else if (cell_idx == 0) begin
                assign next_q[block_idx*BLOCK_SIZE] = 
                    block_left[block_idx][BLOCK_SIZE-1] ^ 
                    q[block_idx*BLOCK_SIZE + 1];
            end
            else begin // cell_idx == BLOCK_SIZE-1
                assign next_q[block_idx*BLOCK_SIZE + BLOCK_SIZE-1] = 
                    q[block_idx*BLOCK_SIZE + BLOCK_SIZE-2] ^ 
                    block_right[block_idx][0];
            end
        end
    end
endgenerate

// Optimized clock gating
wire clk_en = load || (|block_active);

// State update with load functionality
always @(posedge clk) begin
    if (clk_en) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end
end

endmodule