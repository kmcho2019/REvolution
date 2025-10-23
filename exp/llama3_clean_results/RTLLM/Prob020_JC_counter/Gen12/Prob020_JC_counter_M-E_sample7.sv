// Define the module for an 8-bit Johnson counter block
module JC_block_8bit(
    input clk,      // Clock signal
    input rst_n,    // Active-low reset signal
    output reg [7:0] Q  // 8-bit register representing the current count value
);

// Always block for sequential logic
always @(posedge clk or negedge rst_n) begin
    // Reset condition: Set Q to 0 when rst_n is low
    if (~rst_n) begin
        Q <= 8'd0;
    end else begin
        // Update Q based on the current state (Q[0])
        // If Q[0] is 1, shift right and append 0; otherwise, shift right and append 1
        Q <= {Q[0]? 1'b0 : 1'b1, Q[7:1]};
    end
end

endmodule

// Define the top-level module for the 64-bit Johnson counter
module JC_counter(
    input clk,      // Clock signal
    input rst_n,    // Active-low reset signal
    output reg [63:0] Q  // 64-bit register representing the current count value
);

// Instantiate 8 blocks of 8-bit Johnson counters
wire [7:0] block_out [7:0];
JC_block_8bit block_0 (.clk(clk),.rst_n(rst_n),.Q(block_out[0]));
JC_block_8bit block_1 (.clk(clk),.rst_n(rst_n),.Q(block_out[1]));
JC_block_8bit block_2 (.clk(clk),.rst_n(rst_n),.Q(block_out[2]));
JC_block_8bit block_3 (.clk(clk),.rst_n(rst_n),.Q(block_out[3]));
JC_block_8bit block_4 (.clk(clk),.rst_n(rst_n),.Q(block_out[4]));
JC_block_8bit block_5 (.clk(clk),.rst_n(rst_n),.Q(block_out[5]));
JC_block_8bit block_6 (.clk(clk),.rst_n(rst_n),.Q(block_out[6]));
JC_block_8bit block_7 (.clk(clk),.rst_n(rst_n),.Q(block_out[7]));

// Concatenate the outputs of all blocks to form the 64-bit output
always @(block_out) begin
    Q <= {block_out[7], block_out[6], block_out[5], block_out[4], block_out[3], block_out[2], block_out[1], block_out[0]};
end

endmodule