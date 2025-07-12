module right_shifter (
    input wire clk,
    input wire d,
    output wire [7:0] q
);

reg [2:0] ptr = 3'b0;  // 3-bit pointer (0-7)
reg [7:0] buffer;

// Pointer update and data write
always @(posedge clk) begin
    ptr <= (ptr == 3'b0) ? 3'b111 : ptr - 1;  // Circular decrement
    buffer[(ptr + 3'd7) % 8] <= d;            // Write new data at MSB position
end

// Circular readout
assign q = {
    buffer[ptr],
    buffer[(ptr + 1) % 8],
    buffer[(ptr + 2) % 8],
    buffer[(ptr + 3) % 8],
    buffer[(ptr + 4) % 8],
    buffer[(ptr + 5) % 8],
    buffer[(ptr + 6) % 8],
    buffer[(ptr + 7) % 8]
};

endmodule