module TopModule (
    input  clk,
    input  reset,
    output reg [3:0] q
);

    wire count_enable = ~reset;
    wire reached_ten = q[3] & ~q[2] & q[1] & ~q[0]; // binary 1010 decimal 10 detection

    always @(posedge clk) begin
        if (reset) begin
            q <= 4'd1;
        end else if (count_enable) begin
            if (reached_ten)
                q <= 4'd1;
            else
                q <= q + 1'b1;
        end
    end

endmodule