module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

reg [2:0] pos; // 3 bits to represent 8 positions

always @(posedge clk or posedge reset) begin
    if (reset) begin
        pos <= 3'b000; // Initialize to starting position when reset is high
    end else begin
        pos <= (pos + 1) % 8; // Increment position and wrap around to 0 after 7
    end
end

// Continuous assignment to set out based on pos
assign out = (1 << pos);

endmodule