module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0000;
    end
    else if (q[3] & q[0]) begin  // Check for 9 (1001)
        q <= 4'b0000;
    end
    else begin
        q <= q + 1'b1;
    end
end

endmodule