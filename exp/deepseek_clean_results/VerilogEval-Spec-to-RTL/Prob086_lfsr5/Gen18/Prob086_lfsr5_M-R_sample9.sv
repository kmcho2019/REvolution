module TopModule (
    input clk,
    input reset,
    output reg [4:0] q = 1
);

wire [4:0] next_q;

assign next_q = reset ? 5'b00001 : 
               {q[0], 
                q[4], 
                q[3] ^ q[0], 
                q[2], 
                q[1]};

always @(posedge clk)
    q <= next_q;

endmodule