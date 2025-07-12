module right_shifter (
    input wire clk,
    input wire d,
    output wire [7:0] q
);

reg [2:0] ptr = 3'b0;  // Circular buffer pointer
reg [7:0] buffer = 8'b0;

// Circular buffer implementation
always @(posedge clk) begin
    buffer[ptr] <= d;
    ptr <= ptr + 1;
end

// Output generation through pointer-based selection
assign q = {
    buffer[(ptr-1)%8],
    buffer[(ptr-2)%8],
    buffer[(ptr-3)%8],
    buffer[(ptr-4)%8],
    buffer[(ptr-5)%8],
    buffer[(ptr-6)%8],
    buffer[(ptr-7)%8],
    buffer[(ptr-8)%8]
};

endmodule