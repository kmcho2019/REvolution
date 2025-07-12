module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

// Define tap positions as a bitmask
localparam [31:0] TAP_MASK = 32'h80000000 | 32'h00400000 | 32'h00000006;

wire feedback;
wire [31:0] tapped_bits;
wire [31:0] next_q;

// Calculate feedback (XOR of all tapped bits)
assign tapped_bits = q & TAP_MASK;
assign feedback = ^tapped_bits;

// Generate next state: shift right and insert feedback at MSB
assign next_q = reset ? 32'h1 : {feedback, q[31:1]};

always @(posedge clk) begin
    q <= next_q;
end

endmodule