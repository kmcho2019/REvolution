module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

wire feedback = q[0];  // LSB is feedback for Galois LFSR
wire [31:0] next_q;

assign next_q[31] = feedback ^ q[31];  // Tap at 32 (1-based)
assign next_q[30:22] = q[29:21];      // Normal shift
assign next_q[21] = feedback ^ q[21]; // Tap at 22 (1-based)
assign next_q[20:2] = q[19:1];        // Normal shift
assign next_q[1] = feedback ^ q[1];   // Tap at 2 (1-based)
assign next_q[0] = feedback ^ q[0];   // Tap at 1 (1-based)

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end else begin
        q <= next_q;
    end
end

endmodule