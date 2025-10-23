module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

// Use carry-select adder friendly coding style
wire [15:0] next_count = reset ? 16'b0 : 
                        (up_down ? count + 1'b1 : count - 1'b1);
    // Note: Natural wrap-around behavior maintained
    // 65535 + 1 = 0 (via 16-bit overflow)
    // 0 - 1 = 65535 (via 16-bit underflow)

always @(posedge clk) begin
    count <= next_count;
end

endmodule