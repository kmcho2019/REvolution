module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

// Tap positions (32,22,2,1) converted to 0-based (31,21,1,0)
localparam [31:0] TAP_MASK = (1 << 31) | (1 << 21) | (1 << 1) | (1 << 0);

// Create XOR mask by replicating q[0] and masking with tap positions
wire [31:0] xor_mask = TAP_MASK & {32{q[0]}};

// Compute next state: shifted right and XORed with mask, or reset value
wire [31:0] next_q = (q >> 1) ^ xor_mask;
wire [31:0] reset_q = 32'h1;

// Clocked register with synchronous reset
always @(posedge clk) begin
    q <= reset ? reset_q : next_q;
end

endmodule