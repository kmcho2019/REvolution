module LFSR (
    input wire clk,
    input wire rst,
    output reg [3:0] out
);

always @(posedge clk or posedge rst)
    if (rst)
        out <= 4'b0000;  // Initialize to zero as per problem description
    else
        out <= {out[2:0], ~(out[3] ^ out[2])};  // Combined shift and inverted feedback

endmodule