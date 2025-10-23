module LFSR(
    input clk, 
    input rst, 
    output reg [3:0] out
);

always @ (posedge clk or posedge rst) begin
    if (rst) begin
        out <= 4'b0001; // Initialize to a non-zero state to start the sequence
    end else begin
        // Calculate the feedback signal directly and shift the bits
        out <= {out[2:0], ~(out[3] ^ out[2])};
    end
end

endmodule