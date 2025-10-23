module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 10'b0;
    end
    else begin
        // Efficient terminal count check for 999 (1111100111)
        if (&q[9:5] & q[4] & ~q[3] & ~q[2] & &q[1:0]) begin
            q <= 10'b0;
        end
        else begin
            q <= q + 1'b1;
        end
    end
end

endmodule