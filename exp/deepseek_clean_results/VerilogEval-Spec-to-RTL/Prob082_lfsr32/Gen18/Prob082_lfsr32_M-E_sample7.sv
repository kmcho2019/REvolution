module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

// Precompute all XOR operations in parallel
wire tap32_next = q[31] ^ q[0];
wire tap22_next = q[21] ^ q[0];
wire tap2_next  = q[1]  ^ q[0];
wire tap1_next  = q[0]  ^ q[0];  // This will always be 0 (q[0] XOR q[0])

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end else begin
        // Update each segment independently
        q[31] <= tap32_next;       // Tap at 32
        q[30:22] <= q[31:23];      // Non-tapped bits
        q[21] <= tap22_next;        // Tap at 22
        q[20:2] <= q[21:3];        // Non-tapped bits
        q[1] <= tap2_next;          // Tap at 2
        q[0] <= tap1_next;          // Tap at 1
    end
end

endmodule