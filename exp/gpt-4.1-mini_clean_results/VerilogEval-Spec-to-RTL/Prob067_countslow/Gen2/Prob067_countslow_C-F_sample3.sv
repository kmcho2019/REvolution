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
        // Detect if q equals 9 using direct logic: 9 = 4'b1001
        if (q[3] && !q[2] && !q[1] && q[0])
            q <= 4'd0;
        else
            q <= q + 4'd1;
    end
end

endmodule