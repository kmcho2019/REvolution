module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg;
reg [7:0] block_size; // block size is 8 cells

// initialize block size
initial begin
    block_size = 8'd8;
end

// Combinational logic to calculate the next state of each cell
wire [511:0] next_state;

// define the number of blocks
localparam num_blocks = 512 / block_size;

// define the block boundaries
reg [num_blocks-1:0] [7:0] block_left;
reg [num_blocks-1:0] [7:8] block_right;

// calculate the block boundaries
always @(posedge clk) begin
    for (int i = 0; i < num_blocks; i++) begin
        block_left[i] = i * block_size;
        block_right[i] = (i + 1) * block_size - 1;
    end
end

// calculate the next state for each block
genvar i;
generate
    for (i = 0; i < num_blocks; i++) begin
        wire [block_size-1:0] block_next_state;
        // calculate the next state for each cell in the block
        for (int j = 0; j < block_size; j++) begin
            wire left, right;
            // handle the boundary conditions
            if (j == 0) begin
                assign left = (i == 0)? 1'b0 : q_reg[block_left[i] - 1];
                assign right = q_reg[block_left[i] + j + 1];
            end else if (j == block_size - 1) begin
                assign left = q_reg[block_left[i] + j - 1];
                assign right = (i == num_blocks - 1)? 1'b0 : q_reg[block_right[i] + 1];
            end else begin
                assign left = q_reg[block_left[i] + j - 1];
                assign right = q_reg[block_left[i] + j + 1];
            end
            // apply the Rule 90 update rule
            assign block_next_state[j] = left ^ right;
        end
        // assign the next state for the block
        assign next_state[block_left[i] +: block_size] = block_next_state;
    end
endgenerate

// Sequential logic to update q_reg on the positive edge of the clock
always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        q_reg <= next_state;
    end
end

assign q = q_reg;

endmodule