module LFSR(
    input clk, // clock signal
    input rst, // reset signal
    output reg [3:0] out // 4-bit output
);

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin // active high reset
            out <= 4'd0; // initialize the register to zero
        end else begin
            // calculate the feedback signal by XORing the most significant bit and the second most significant bit, then inverting
            reg [3:0] next_out;
            next_out[3:1] = out[2:0]; // shift the bits left
            next_out[0] = ~(out[3] ^ out[2]); // insert the inverted feedback at the LSB
            out <= next_out;
        end
    end

endmodule