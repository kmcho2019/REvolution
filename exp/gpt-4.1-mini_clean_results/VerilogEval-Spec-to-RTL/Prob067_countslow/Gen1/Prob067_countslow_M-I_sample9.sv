module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 4'd0;
    end else if (slowena) begin
        // If count is 9, wrap around to 0, else increment.
        // Implement comparison as (q == 9) using bits directly:
        // 9 decimal = 4'b1001
        // We can check q[3]&~q[2]&~q[1]&q[0]
        if (q[3] & ~q[2] & ~q[1] & q[0])
            q <= 4'd0;
        else
            q <= q + 1'b1;
    end
end

endmodule