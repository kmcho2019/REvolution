module up_down_counter (
    input clk,         // Clock signal
    input reset,       // Reset signal
    input up_down,     // Control signal for counting direction
    output reg [15:0] count  // 16-bit output representing the current counter value
);

reg [15:0] inc_count;  // Increment counter
reg [15:0] dec_count;  // Decrement counter

// Increment counter
always @ (posedge clk) begin
    if (reset) begin
        inc_count <= 16'd0;
    end else if (up_down) begin
        inc_count <= inc_count + 1;
    end
end

// Decrement counter
always @ (*) begin
    if (reset) begin
        dec_count <= 16'd0;
    end else if (!up_down) begin
        dec_count <= dec_count - 1;
    end
end

// Output logic
always @ (*) begin
    if (up_down) begin
        count = inc_count;
    end else begin
        count = dec_count;
    end
end

// Reset pulse generator
reg reset_pulse;
always @ (posedge clk) begin
    if (reset) begin
        reset_pulse <= 1'b1;
    end else begin
        reset_pulse <= 1'b0;
    end
end

// Reset logic
always @ (posedge clk) begin
    if (reset_pulse) begin
        inc_count <= 16'd0;
        dec_count <= 16'd0;
    end
end

endmodule