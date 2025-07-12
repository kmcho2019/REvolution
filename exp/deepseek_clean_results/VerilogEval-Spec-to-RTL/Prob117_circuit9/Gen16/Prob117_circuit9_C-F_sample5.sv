module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

always @(posedge clk) begin
    if (a) begin
        q <= 3'd4;  // Force output to 4 when a is high
    end else begin
        // Efficient wrap-around using bitwise check
        if (&q[1:0] && q[2]) begin  // q == 3'd6 (110)
            q <= 3'd0;
        end else begin
            q <= q + 1'b1;  // Increment otherwise
        end
    end
end

endmodule