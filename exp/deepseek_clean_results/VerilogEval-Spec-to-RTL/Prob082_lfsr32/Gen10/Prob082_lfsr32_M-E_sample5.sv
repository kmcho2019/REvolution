module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

wire [31:0] next_q;

// Parallel XOR network for all taps
assign next_q[31] = q[0];  // Position 32 (MSB)
assign next_q[30:22] = q[31:23];  // Untapped positions
assign next_q[21] = q[22] ^ q[0];  // Position 22
assign next_q[20:2] = q[21:3];  // Untapped positions
assign next_q[1] = q[2] ^ q[0];  // Position 2
assign next_q[0] = q[1] ^ q[0];  // Position 1

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end
    else begin
        q <= next_q;
    end
end

endmodule