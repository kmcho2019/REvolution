module TopModule (
    input  clk,
    input  reset,
    output reg [3:0] q
);

    // Count enable is high only when not in reset, preventing toggling during reset
    wire count_enable = ~reset;
    // Minimal combinational condition to detect decimal 10 (1010)
    wire reached_ten = q[3] & ~q[2] & q[1] & ~q[0];

    always @(posedge clk) begin
        if (reset) begin
            q <= 4'd1;               // Synchronous reset to 1
        end else if (count_enable) begin
            if (reached_ten)
                q <= 4'd1;           // Wrap around to 1 after 10
            else
                q <= q + 1'b1;       // Increment otherwise
        end
        // If count_enable is low (should only be during reset), hold current value
    end

endmodule