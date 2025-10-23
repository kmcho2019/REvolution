module LFSR(
    input clk, 
    input rst, 
    output reg [3:0] out
);

always @ (posedge clk or posedge rst) begin
    if (rst) 
        out <= 4'b0;
    else 
        out <= {out[2:0], ~(out[3] ^ out[2])};
end

endmodule