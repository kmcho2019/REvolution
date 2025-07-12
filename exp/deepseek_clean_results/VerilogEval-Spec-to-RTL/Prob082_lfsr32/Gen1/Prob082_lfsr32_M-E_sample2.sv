module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

wire [31:0] next_q;

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end
    else begin
        q <= next_q;
    end
end

// Galois LFSR implementation
assign next_q[31] = q[0];  // New MSB comes from LSB
assign next_q[30:22] = q[31:23];  // Untapped bits shift right
assign next_q[21] = q[22] ^ q[0];  // Tap at position 22 (0-based 21)
assign next_q[20:2] = q[21:3];  // Untapped bits shift right
assign next_q[1] = q[2] ^ q[0];  // Tap at position 2 (0-based 1)
assign next_q[0] = q[1] ^ q[0];  // Tap at position 1 (0-based 0)

endmodule