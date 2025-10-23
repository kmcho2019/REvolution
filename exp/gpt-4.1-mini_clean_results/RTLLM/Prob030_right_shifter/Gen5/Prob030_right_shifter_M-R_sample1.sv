module right_shifter(
    input clk,
    input d,
    output reg [7:0] q
);

reg [6:0] shifted_part;
reg msb_bit;

initial begin
    q = 8'b0;
    shifted_part = 7'b0;
    msb_bit = 1'b0;
end

// Shift the lower 7 bits to the right on clock edge
always @(posedge clk) begin
    shifted_part <= q[7:1];
end

// Load the new MSB bit on clock edge
always @(posedge clk) begin
    msb_bit <= d;
end

// Combine shifted part and new MSB bit into q
always @(posedge clk) begin
    q <= {msb_bit, shifted_part};
end

endmodule