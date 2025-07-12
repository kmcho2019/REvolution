module LFSR(
    input clk, 
    input rst, 
    output reg [3:0] out
);

always @ (posedge clk or posedge rst) begin
    if (rst) begin
        out <= 4'b0000; // Initialize to zero on reset
    end else begin
        // Calculate feedback as the inversion of XOR of MSB and second MSB
        out <= {out[2:0], ~(out[3] ^ out[2])};
    end
end

endmodule