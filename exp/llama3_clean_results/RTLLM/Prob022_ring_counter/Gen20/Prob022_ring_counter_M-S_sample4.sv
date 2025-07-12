module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

reg [2:0] pos; // 3 bits to represent 8 positions

always @(posedge clk or posedge reset) begin
    if (reset) begin
        pos <= 0; // Reset position to 0
    end else begin
        if (pos == 7) begin
            pos <= 0; // Wrap around to 0 after 7
        end else begin
            pos <= pos + 1; // Increment position
        end
    end
    
    // Calculate output based on current position
    out <= (1 << pos); // Shift the bit to the left by pos places
end

endmodule