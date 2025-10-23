module right_shifter (
    input wire clk,
    input wire d,
    output reg [7:0] q
);

reg [2:0] wr_ptr = 0;  // 3-bit pointer for 8 positions
reg [7:0] buffer = 0;  // Storage buffer

always @(posedge clk) begin
    // Store new data at current pointer position
    buffer[wr_ptr] <= d;
    
    // Update pointer (wraps around after 7)
    wr_ptr <= wr_ptr + 1;
    
    // Generate output by reading from pointer backwards
    q <= {buffer[wr_ptr], 
          buffer[wr_ptr-1], 
          buffer[wr_ptr-2], 
          buffer[wr_ptr-3], 
          buffer[wr_ptr-4], 
          buffer[wr_ptr-5], 
          buffer[wr_ptr-6], 
          buffer[wr_ptr-7]};
end

endmodule