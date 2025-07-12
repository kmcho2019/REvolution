module right_shifter (
    input wire clk,
    input wire d,
    output reg [7:0] q
);

reg [2:0] wr_ptr;  // Write pointer (0-7)
reg [7:0] buffer;  // Circular buffer storage

always @(posedge clk) begin
    // Update the write pointer (decrement with wrap-around)
    wr_ptr <= (wr_ptr == 3'b0) ? 3'b111 : (wr_ptr - 1);
    
    // Write new data to current pointer position
    buffer[wr_ptr] <= d;
    
    // Generate output by reading from circular buffer
    for (integer i = 0; i < 8; i = i + 1) begin
        q[i] <= buffer[(wr_ptr + 1 + i) % 8];
    end
end

initial begin
    wr_ptr = 3'b111;  // Start at position 7
    buffer = 8'b0;
    q = 8'b0;
end

endmodule