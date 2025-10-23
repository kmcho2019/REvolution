module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

always @(posedge clk) begin
    if (reset) begin
        count <= 16'b0;
    end else begin
        if (up_down) begin
            // Simple increment (ripple carry)
            count <= count + 1'b1;
        end else begin
            // Efficient decrement using two's complement trick:
            // count - 1 = count + (-1) = count + 16'hFFFF
            count <= count + 16'hFFFF;
        end
    end
end

endmodule