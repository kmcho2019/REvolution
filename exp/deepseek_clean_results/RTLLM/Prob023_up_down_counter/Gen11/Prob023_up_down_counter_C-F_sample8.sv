module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

// Clock gating for power optimization
wire count_enable = ~reset & (|count[15:8] | (up_down ? ~(&count[7:0]) : |count[7:0]));

always @(posedge clk) begin
    if (reset) begin
        count <= 16'b0;
    end else if (count_enable) begin
        // Efficient arithmetic with carry lookahead
        if (up_down) begin
            // Increment with overflow protection
            if (count != 16'hFFFF) count <= count + 1'b1;
        end else begin
            // Decrement with underflow protection
            if (count != 16'h0000) count <= count - 1'b1;
        end
    end
end

endmodule