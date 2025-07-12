module LFSR(
    input clk, // Clock signal
    input rst, // Active high reset signal
    output reg [3:0] out // 4-bit output representing the current state
);

// Initialize the output with a default value to avoid undefined behavior
initial out = 4'b0000;

// On every positive edge of the clock
always @(posedge clk) begin
    // If reset is high, initialize the register to zero
    if (rst) begin
        out <= 4'b0000;
    end else begin
        // Calculate the feedback signal by XORing the most significant bit and the second most significant bit
        // The result is inverted to produce the feedback signal
        reg [3:0] temp_out;
        temp_out = out;
        out <= {temp_out[2:0], ~(temp_out[3] ^ temp_out[2])};
    end
end

endmodule