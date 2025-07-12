module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    wire count_enable = ~reset;

    always @(posedge clk) begin
        if (reset) begin
            q <= 4'd1;  // synchronous reset to 1
        end else if (count_enable) begin
            // If q is 10, wrap to 1; else increment
            // Using a simple ternary operator to reduce comparator complexity
            q <= (q == 4'd10) ? 4'd1 : q + 4'd1;
        end
    end

endmodule