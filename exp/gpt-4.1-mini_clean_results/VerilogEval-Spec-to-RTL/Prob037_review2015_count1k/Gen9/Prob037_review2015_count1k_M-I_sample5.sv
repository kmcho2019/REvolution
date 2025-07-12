module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

    // Terminal count detection for 999 (decimal) = 10'b 11_1110_0111
    wire terminal_count;
    assign terminal_count = q[9] & q[8] & q[7] & q[6] & ~q[5] & ~q[4] & q[3] & q[2] & q[1] & q[0];

    always @(posedge clk) begin
        if (reset) begin
            q <= 10'd0;
        end else if (terminal_count) begin
            q <= 10'd0;
        end else begin
            q <= q + 10'd1;
        end
    end

endmodule