module LFSR(
    input clk,
    input rst,
    output reg [3:0] out
);

always @ (posedge clk) begin
    if (rst) begin
        out <= 4'b0000; // Reset the LFSR to zero when rst is high
    end else begin
        // Calculate the feedback signal directly within the shift operation
        // by XORing out[3] and out[2], then inverting the result
        out <= {out[2:0], ~(out[3] ^ out[2])};
    end
end

endmodule