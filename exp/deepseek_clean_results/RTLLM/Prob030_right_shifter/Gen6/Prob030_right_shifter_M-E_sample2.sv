module right_shifter (
    input wire clk,
    input wire d,
    output reg [7:0] q
);

reg [2:0] ptr;  // Pointer to current MSB position

initial begin
    q = 8'b0;
    ptr = 3'b0;
end

always @(posedge clk) begin
    // Update the circular buffer
    q[ptr] <= d;
    
    // Update pointer (modulo 8)
    ptr <= (ptr == 3'd7) ? 3'd0 : ptr + 3'd1;
    
    // The output appears shifted because we're reading with an offset
    // The actual shifting happens conceptually when reading the output
end

// Output is effectively a rotated version of the buffer
// This creates the right-shift effect without actual shifting
assign q = {q[ptr-1:0], q[7:ptr]};

endmodule