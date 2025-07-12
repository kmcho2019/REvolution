module up_down_counter (
    input clk,         // Clock signal
    input reset,       // Reset signal
    input up_down,     // Control signal for counting direction
    output reg [15:0] count  // 16-bit output representing the current counter value
);

reg [15:0] adder_out;
reg [15:0] subtractor_out;
reg [15:0] next_count;

// Adder module
always @ (*) begin
    adder_out = count + 1;
end

// Subtractor module
always @ (*) begin
    subtractor_out = count - 1;
    if (subtractor_out > count) begin
        subtractor_out = 16'd65535;
    end
end

// Multiplexer to select between adder and subtractor output
always @ (*) begin
    if (up_down) begin
        next_count = adder_out;
    end else begin
        next_count = subtractor_out;
    end
end

// Register to store the current count value
always @ (posedge clk) begin
    if (reset) begin
        count <= 16'd0;
    end else begin
        count <= next_count;
    end
end

endmodule