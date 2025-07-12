module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 4'd1;
        end else begin
            // Instead of (q == 10), check for count 10 with minimal logic
            // 10 in binary is 1010
            // Condition to detect 10 can be: q[3] & ~q[2] & q[1] & ~q[0]
            if ((q[3] & ~q[2] & q[1] & ~q[0]) == 1'b1) 
                q <= 4'd1;
            else
                q <= q + 1'b1;
        end
    end

endmodule