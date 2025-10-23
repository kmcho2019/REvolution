module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

wire tap_xor = q[0];
wire [31:0] next_q = reset ? 32'h1 : 
                    {tap_xor, 
                     q[31:23], 
                     q[22] ^ tap_xor, 
                     q[21:3], 
                     q[2] ^ tap_xor, 
                     q[1] ^ tap_xor};

always @(posedge clk) begin
    q <= next_q;
end

endmodule