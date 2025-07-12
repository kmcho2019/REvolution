module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output [99:0] q
);

parameter BLOCK_SIZE = 25;
parameter NUM_BLOCKS = 4;

reg [BLOCK_SIZE-1:0] blocks [NUM_BLOCKS-1:0];

// Handle sequential logic in a single always block
always @(posedge clk) begin
    if (load) begin
        // Load the blocks with data
        for (int i = 0; i < NUM_BLOCKS; i++) begin
            blocks[i] <= data[(i*BLOCK_SIZE + BLOCK_SIZE - 1) : (i*BLOCK_SIZE)];
        end
    end else begin
        case (ena)
            2'b01: begin // Rotate right
                reg [BLOCK_SIZE-1:0] temp;
                temp = blocks[NUM_BLOCKS-1];
                for (int i = NUM_BLOCKS-1; i > 0; i--) begin
                    blocks[i] <= blocks[i-1];
                end
                blocks[0] <= temp;
            end
            2'b10: begin // Rotate left
                reg [BLOCK_SIZE-1:0] temp;
                temp = blocks[0];
                for (int i = 0; i < NUM_BLOCKS-1; i++) begin
                    blocks[i] <= blocks[i+1];
                end
                blocks[NUM_BLOCKS-1] <= temp;
            end
            default: begin // No rotation
                for (int i = 0; i < NUM_BLOCKS; i++) begin
                    blocks[i] <= blocks[i];
                end
            end
        endcase
    end
end

// Concatenate the blocks to form the output
assign q = {blocks[NUM_BLOCKS-1], blocks[NUM_BLOCKS-2], blocks[NUM_BLOCKS-3], blocks[0]};

endmodule