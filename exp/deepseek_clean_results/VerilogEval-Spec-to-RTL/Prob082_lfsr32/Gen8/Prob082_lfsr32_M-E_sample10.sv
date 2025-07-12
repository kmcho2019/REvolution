module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

// Tap positions: 32, 22, 2, 1 (note: bit 32 is actually q[31] in 0-based indexing)
// Create a mask where tap positions are set to 1
wire [31:0] tap_mask = 32'b10000000000100000000000000000011;

wire feedback = q[0];
wire [31:0] xor_result = q ^ {32{feedback}};
wire [31:0] next_q = reset ? 32'h1 : 
                    {feedback, xor_result[31:1]} & tap_mask | 
                    {feedback, q[31:1]} & ~tap_mask;

always @(posedge clk) begin
    q <= next_q;
end

endmodule