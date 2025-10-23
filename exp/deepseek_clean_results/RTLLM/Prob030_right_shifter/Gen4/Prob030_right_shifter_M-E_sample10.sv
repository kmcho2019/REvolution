module right_shifter (
    input clk,
    input d,
    output [7:0] q
);

reg [7:0] buffer;
reg [2:0] ptr;  // 3-bit pointer for 8 positions
integer i;

// Circular buffer implementation
always @(posedge clk) begin
    buffer[ptr] <= d;
    ptr <= ptr + 1;  // Automatically wraps around
end

// Output generation (combinational)
always @(*) begin
    for (i = 0; i < 8; i = i + 1) begin
        q[i] = buffer[(ptr - 1 - i) % 8];
    end
end

// Initialization
initial begin
    buffer = 8'b0;
    ptr = 0;
end

endmodule