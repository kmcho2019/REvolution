module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    // Detect decimal 10 (binary 1010) using minimal combinational logic
    wire reached_ten = q[3] & ~q[2] & q[1] & ~q[0];
    wire count_enable = ~reset;  // Counting enabled only when reset is not asserted

    always @(posedge clk) begin
        if (reset) begin
            q <= 4'd1;             // synchronous reset to 1
        end else if (count_enable) begin
            if (reached_ten)
                q <= 4'd1;         // wrap around to 1 after 10
            else
                q <= q + 4'd1;
        end
    end

endmodule