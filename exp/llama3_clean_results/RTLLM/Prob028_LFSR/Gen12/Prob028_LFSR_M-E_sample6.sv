module LFSR(
    input clk, 
    input rst, 
    output reg [3:0] out
);

always @ (posedge clk or posedge rst) begin
    if (rst) begin
        // Initialize to a non-zero state
        out <= 4'b1000; // All zeros would cause the LFSR to produce a constant sequence
    end else begin
        // Calculate the next state using the polynomial x^4 + x + 1
        // This corresponds to out[3] being the MSB (x^4 term) and out[0] being the constant term
        out <= {out[2:0], out[3] ^ out[0]};
    end
end

endmodule