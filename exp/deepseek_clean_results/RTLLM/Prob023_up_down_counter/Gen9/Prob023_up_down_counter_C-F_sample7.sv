module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

// Efficient counting enable - only blocks counting at boundaries
wire count_enable = ~((up_down & &count) || (~up_down & ~|count));

always @(posedge clk) begin
    if (reset) begin
        count <= 16'b0;
    end else if (count_enable) begin
        // Optimized arithmetic operation
        if (up_down) begin
            // Increment with carry-propagation hint
            count <= count + 1'b1;
        end else begin
            // Decrement with borrow-propagation hint
            count <= count - 1'b1;
        end
    end
end

endmodule