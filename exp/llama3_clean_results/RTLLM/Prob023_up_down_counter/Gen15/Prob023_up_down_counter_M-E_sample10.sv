module up_down_counter (
    input clk,         // Clock signal
    input reset,       // Reset signal
    input up_down,     // Control signal for counting direction
    output reg [15:0] count  // 16-bit output representing the current counter value
);

reg [15:0] adder_result;

// Parallel adder/subtractor implementation
always @ (*) begin
    if (up_down) begin
        adder_result = count + 1;
    end else begin
        adder_result = count - 1;
    end
end

always @ (posedge clk) begin
    if (reset) begin
        count <= 16'd0;
    end else begin
        count <= adder_result;
    end
end

endmodule