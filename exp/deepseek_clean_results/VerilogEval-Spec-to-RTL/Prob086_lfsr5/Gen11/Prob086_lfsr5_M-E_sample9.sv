module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

wire [4:0] next_q;

// Parallel computation of next state
assign next_q[4] = q[0];                    // MSB comes from LSB
assign next_q[3] = q[4];                    // Simple shift
assign next_q[2] = q[3] ^ q[0];             // Tap at position 3
assign next_q[1] = q[2];                    // Simple shift
assign next_q[0] = q[1] ^ q[0];             // Tap at position 5 (implied by XOR)

always @(posedge clk) begin
    q <= reset ? 5'b00001 : next_q;
end

endmodule