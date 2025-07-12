module right_shifter (
    input wire clk,
    input wire d,
    output reg [7:0] q
);

// Circular buffer storage
reg [7:0] buffer [0:7];
reg [2:0] ptr;  // Pointer to current start position

// Initialize buffer and pointer
integer i;
initial begin
    for (i = 0; i < 8; i = i + 1) begin
        buffer[i] = 1'b0;
    end
    ptr = 3'b0;
end

// Update buffer and pointer on clock edge
always @(posedge clk) begin
    // Store new input at previous head position
    buffer[ptr] <= d;
    
    // Update pointer (decrement with wrap-around)
    ptr <= (ptr == 3'b0) ? 3'b111 : (ptr - 1);
    
    // Generate output by reading circular buffer
    q <= {
        buffer[(ptr+0)%8],
        buffer[(ptr+1)%8],
        buffer[(ptr+2)%8],
        buffer[(ptr+3)%8],
        buffer[(ptr+4)%8],
        buffer[(ptr+5)%8],
        buffer[(ptr+6)%8],
        buffer[(ptr+7)%8]
    };
end

endmodule