module up_down_counter (
    input clk,         // Clock signal
    input reset,       // Reset signal
    input up_down,     // Control signal for counting direction
    output reg [15:0] count  // 16-bit output representing the current counter value
);

always @ (posedge clk) begin
    if (reset) begin
        count <= 16'd0;
    end else begin
        if (up_down) begin
            // Increment count directly
            count <= count + 1;
        end else begin
            // Decrement count by adding the two's complement of 1
            count <= count + 16'b11111111_11111111; // -1 in two's complement for 16 bits
        end
    end
end

endmodule