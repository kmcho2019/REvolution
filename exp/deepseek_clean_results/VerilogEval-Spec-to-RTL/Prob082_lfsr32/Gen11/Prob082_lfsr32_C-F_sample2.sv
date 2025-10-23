module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

wire lsb_xor = q[0];
wire [31:0] next_q = reset ? 32'h1 : 
                    {lsb_xor,
                     q[31:23],
                     q[22] ^ lsb_xor,
                     q[21:3],
                     {q[2:1] ^ {2{lsb_xor}}};

always @(posedge clk) begin
    q <= next_q;
end

endmodule