module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

// Parallel XOR network for all tap positions
wire [31:0] next_q;
assign next_q[31] = q[0];  // Position 32 (MSB) gets q[0] due to right shift
assign next_q[30:22] = q[31:23];  // Unaffected bits
assign next_q[21] = q[22] ^ q[0];  // Tap at 22
assign next_q[20:2] = q[21:3];  // Unaffected bits
assign next_q[1] = q[2] ^ q[0];  // Tap at 2
assign next_q[0] = q[1] ^ q[0];  // Tap at 1

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end else begin
        q <= next_q;
    end
end

endmodule