module right_shifter (
    input clk,
    input d,
    output reg [7:0] q = 0
);

reg [2:0] write_ptr = 3'b0;  // 3-bit pointer (0-7)
reg [7:0] buffer = 8'b0;

always @(posedge clk) begin
    // Update the buffer at current pointer position
    buffer[write_ptr] <= d;
    
    // Increment pointer (wraps around after 7)
    write_ptr <= write_ptr + 1;
    
    // Output is always the full buffer, but ordered from write_ptr+1 to write_ptr
    // This creates the right-shift effect without actual shifting
    q <= {buffer[write_ptr-1], buffer[write_ptr-2], buffer[write_ptr-3],
          buffer[write_ptr-4], buffer[write_ptr-5], buffer[write_ptr-6],
          buffer[write_ptr-7], buffer[write_ptr]};
end

endmodule