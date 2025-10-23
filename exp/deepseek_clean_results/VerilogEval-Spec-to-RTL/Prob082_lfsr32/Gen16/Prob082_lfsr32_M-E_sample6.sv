module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

// Tap mask: bits 31,21,1,0 are tapped (positions 32,22,2,1 in 1-based indexing)
localparam [31:0] TAP_MASK = 32'b11000000000000000000010000000011;

wire [31:0] xor_result = {32{q[0]}} & TAP_MASK;
wire [31:0] next_val = reset ? 32'h1 : 
                      (({q[30:0], 1'b0}) ^ xor_result);

always @(posedge clk) begin
    q <= next_val;
end

endmodule