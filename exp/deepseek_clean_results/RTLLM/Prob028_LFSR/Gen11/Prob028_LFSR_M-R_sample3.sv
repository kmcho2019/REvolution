module LFSR (
    input  wire clk,
    input  wire rst,
    output reg  [3:0] out
);

wire feedback = ~(out[3] ^ out[2]);  // XOR bits 3 and 2, then invert

assign out = (posedge clk) ? 
             (rst ? 4'b0000 : {out[2:0], feedback}) : 
             out;

endmodule