module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

wire [31:0] next_q;

assign next_q[31] = q[0];
assign next_q[30:23] = q[31:24];  // Untapped bits
assign next_q[22] = q[23] ^ q[0]; // Tap at 22
assign next_q[21:3] = q[22:4];    // Untapped bits
assign next_q[2] = q[3] ^ q[0];   // Tap at 2
assign next_q[1] = q[2] ^ q[0];   // Tap at 1
assign next_q[0] = q[1];          // Final shift

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end else begin
        q <= next_q;
    end
end

endmodule