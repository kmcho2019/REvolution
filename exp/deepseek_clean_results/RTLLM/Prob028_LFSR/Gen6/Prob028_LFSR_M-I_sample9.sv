module LFSR #(parameter WIDTH = 4) (
    input clk,
    input rst,
    output reg [WIDTH-1:0] out
);

// 4-bit LFSR with feedback from bits 3 and 2
always @(posedge clk or posedge rst)
    out <= rst ? {WIDTH{1'b0}} : {out[WIDTH-2:0], ~(out[WIDTH-1] ^ out[WIDTH-2])};

endmodule