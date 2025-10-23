module up_down_counter (
    input wire clk,
    input wire reset,
    input wire up_down,
    output reg [15:0] count
);

always @(posedge clk) begin
    if (reset)
        count <= 16'd0;
    else
        // Combine increment and decrement into one line using a signed addition
        count <= count + (up_down ? 16'sd1 : -16'sd1);
end

endmodule