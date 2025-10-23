module right_shifter (
    input clk,
    input d,
    output reg [7:0] q
);

reg [7:0] buffer;
reg [2:0] ptr = 3'b0;  // Pointer to current MSB position

always @(posedge clk) begin
    // Store new input at pointer position
    buffer[ptr] <= d;
    
    // Update pointer (circular buffer)
    ptr <= ptr + 1;
    
    // Generate output by reading from buffer with offset
    for (integer i = 0; i < 8; i = i + 1) begin
        q[i] <= buffer[(ptr + i) % 8];
    end
end

endmodule