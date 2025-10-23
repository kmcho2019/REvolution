module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

wire [31:0] next_q;
wire feedback = q[0];

assign next_q = reset ? 32'h1 : 
                {feedback, 
                 q[31:23], 
                 q[22] ^ feedback, 
                 q[21:3], 
                 q[2] ^ feedback, 
                 q[1] ^ feedback};

always @(posedge clk) begin
    q <= next_q;
end

endmodule