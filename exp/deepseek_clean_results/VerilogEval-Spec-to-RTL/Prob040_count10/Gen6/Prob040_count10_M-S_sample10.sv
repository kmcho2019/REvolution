module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 0;
    end
    else if (q[3] & q[0]) begin  // 9 = 1001
        q <= 0;
    end
    else begin
        q <= q + 1;
    end
end

endmodule