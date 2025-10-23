module LFSR (
    input clk,
    input rst,
    output reg [3:0] out
);

wire feedback;
assign feedback = out[3] ^ out[2];

always @(posedge clk or posedge rst)
    if (rst)
        out <= 4'b0001;
    else
        out <= {out[2:0], feedback};

endmodule