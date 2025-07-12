module TopModule (
    input clk,
    input reset,
    output [3:0] q
);

reg [15:0] ring_counter;

// Binary decoder
wire [3:0] binary_out;
assign binary_out[0] = |ring_counter[14:0:2];  // Odd positions
assign binary_out[1] = |ring_counter[12:0:4];  // Every 4th position starting from 12
assign binary_out[2] = |ring_counter[8:0:8];   // Every 8th position starting from 8
assign binary_out[3] = |ring_counter[15:8];    // Upper half

always @(posedge clk) begin
    if (reset) begin
        ring_counter <= 16'b0000000000000001;  // Initialize to position 0
    end else begin
        // Rotate right
        ring_counter <= {ring_counter[0], ring_counter[15:1]};
    end
end

assign q = binary_out;

endmodule