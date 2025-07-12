module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

parameter MAX_COUNT = 4'd9;  // Parameter for maintainability

always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0000;
    end
    else begin
        if (q[3] & q[0]) begin  // Efficient detection of 9 (1001)
            q <= 4'b0000;
        end
        else begin
            q <= q + 1'b1;     // Simple increment operation
        end
    end
end

endmodule