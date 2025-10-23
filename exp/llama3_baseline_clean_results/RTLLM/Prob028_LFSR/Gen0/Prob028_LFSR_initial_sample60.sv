module LFSR (
    input clk,
    input rst,
    output [3:0] out
);

reg [3:0] out;

always @(posedge clk) begin
    if (rst) begin
        // Initialize the register to zero on reset
        out <= 4'b0000;
    end else begin
        // Calculate the feedback signal
        reg [3:0] next_out;
        next_out[3] = out[2];
        next_out[2] = out[1];
        next_out[1] = out[0];
        next_out[0] = ~(out[3] ^ out[2]);  // Inverted XOR of MSB and second MSB
        out <= next_out;
    end
end

endmodule