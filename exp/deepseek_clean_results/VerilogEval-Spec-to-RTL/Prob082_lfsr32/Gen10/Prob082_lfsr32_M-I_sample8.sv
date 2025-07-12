module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

wire [31:0] next_q = reset ? 32'h1 : 
                    {q[0], 
                     q[31:22] ^ {22{q[0]}},  // XOR all bits 31-22 with q[0]
                     q[21:2], 
                     q[1] ^ q[0], 
                     q[0] ^ q[0]};           // q[0] XOR q[0] = 0 (for bit position 1)

always @(posedge clk) begin
    q <= next_q;
end

endmodule