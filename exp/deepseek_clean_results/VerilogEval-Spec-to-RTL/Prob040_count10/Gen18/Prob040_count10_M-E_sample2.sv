module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

wire feedback_bit = ~(q[3] & q[0]);  // 0 when count=9 (1001), else 1

always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0000;
    end else begin
        q <= {q[2:0], feedback_bit};
    end
end

endmodule