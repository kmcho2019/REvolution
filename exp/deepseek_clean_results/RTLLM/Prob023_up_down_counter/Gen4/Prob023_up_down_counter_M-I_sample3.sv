module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

// Clock gating control
wire count_enable = ~reset;  // Counting enabled when not in reset

// Registered direction control
reg direction;
always @(posedge clk) begin
    if (reset) begin
        direction <= 1'b0;  // Default direction (doesn't matter during reset)
    end else begin
        direction <= up_down;
    end
end

// Arithmetic operation with shared resources
always @(posedge clk) begin
    if (reset) begin
        count <= 16'b0;
    end else if (count_enable) begin
        // Simple adder with direction control
        // Natural wrap-around: 65535+1=0, 0-1=65535
        count <= direction ? count + 1'b1 : count - 1'b1;
    end
end

endmodule