// Define a module for the increment/decrement logic
module counter_logic (
    input [15:0] current_count,
    input up_down,
    output reg [15:0] next_count
);

always @ (*) begin
    if (up_down) begin
        next_count = (current_count + 1) % 65536;
    end else begin
        next_count = (current_count - 1 + 65536) % 65536;
    end
end

endmodule

// Define the main up_down_counter module
module up_down_counter (
    input clk,         // Clock signal
    input reset,       // Reset signal
    input up_down,     // Control signal for counting direction
    output reg [15:0] count  // 16-bit output representing the current counter value
);

reg [15:0] next_count;

// Instantiate the counter_logic module
counter_logic counter_logic_instance (
   .current_count(count),
   .up_down(up_down),
   .next_count(next_count)
);

// Update the counter state on the rising edge of the clock signal
always @ (posedge clk) begin
    if (reset) begin
        count <= 16'd0;
    end else begin
        count <= next_count;
    end
end

endmodule