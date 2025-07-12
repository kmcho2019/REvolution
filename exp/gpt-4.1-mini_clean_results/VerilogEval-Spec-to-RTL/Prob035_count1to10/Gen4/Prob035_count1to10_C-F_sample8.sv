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
            // Use bitwise detection of decimal 10 (1010)
            if ((q[3] & ~q[2] & q[1] & ~q[0]) == 1'b1)
                q <= 4'd1;
            else
                q <= q + 4'd1;
        end
    end

endmodule