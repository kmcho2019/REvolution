module up_down_counter (
    input clk,         // Clock signal
    input reset,       // Reset signal
    input up_down,     // Control signal for counting direction
    output reg [15:0] count  // 16-bit output representing the current counter value
);

// Direction Controller
reg direction;
always @(*) begin
    if (up_down) begin
        direction = 1'b1; // Increment
    end else begin
        direction = 1'b0; // Decrement
    end
end

// Reset Controller
reg reset_state;
always @(*) begin
    if (reset) begin
        reset_state = 1'b1; // Reset active
    end else begin
        reset_state = 1'b0; // Reset inactive
    end
end

// Counter Core
reg [15:0] next_count;
always @ (posedge clk) begin
    if (reset_state) begin
        count <= 16'd0;
    end else if (direction) begin
        // Increment
        if (count == 16'd65535) begin
            count <= 16'd0;
        end else begin
            count <= count + 1;
        end
    end else begin
        // Decrement
        if (count == 16'd0) begin
            count <= 16'd65535;
        end else begin
            count <= count - 1;
        end
    end
end

endmodule