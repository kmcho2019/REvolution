module up_down_counter (
    input clk,         // Clock signal
    input reset,       // Reset signal
    input up_down,     // Control signal for counting direction
    output reg [15:0] count  // 16-bit output representing the current counter value
);

reg [7:0] low_bits;  // Synchronous counter for lower 8 bits
reg [7:0] high_bits; // Asynchronous counter for higher 8 bits

always @ (posedge clk) begin
    if (reset) begin
        low_bits <= 8'd0;
        high_bits <= 8'd0;
    end else begin
        if (up_down) begin
            // Increment low bits
            low_bits <= low_bits + 1;
            // Check for overflow and increment high bits if necessary
            if (low_bits == 8'd0) begin
                high_bits <= high_bits + 1;
            end
        end else begin
            // Decrement low bits
            low_bits <= low_bits - 1;
            // Check for underflow and decrement high bits if necessary
            if (low_bits == 8'd255) begin
                high_bits <= high_bits - 1;
            end
        end
    end
end

assign count = {high_bits, low_bits};

endmodule