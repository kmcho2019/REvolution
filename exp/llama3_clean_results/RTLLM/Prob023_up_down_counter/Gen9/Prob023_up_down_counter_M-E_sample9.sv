module up_down_counter (
    input clk,         // Clock signal
    input reset,       // Reset signal
    input up_down,     // Control signal for counting direction
    output reg [15:0] count  // 16-bit output representing the current counter value
);

reg [15:0] increment_count;
reg [15:0] decrement_count;

always @ (posedge clk) begin
    if (reset) begin
        increment_count <= 16'd0;
        decrement_count <= 16'd0;
        count <= 16'd0;
    end else begin
        // Increment counter
        increment_count <= (increment_count == 16'd65535) ? 16'd0 : increment_count + 1;
        
        // Decrement counter
        decrement_count <= (decrement_count == 16'd0) ? 16'd65535 : decrement_count - 1;
        
        // Select output based on up_down signal
        if (up_down) begin
            count <= increment_count;
        end else begin
            count <= decrement_count;
        end
    end
end

endmodule