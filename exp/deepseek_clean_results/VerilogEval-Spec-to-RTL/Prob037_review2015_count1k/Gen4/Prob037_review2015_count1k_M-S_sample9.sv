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
        // Check if all three digits are 9 (equivalent to 999)
        if (q[3:0] == 4'd9 && q[7:4] == 4'd9 && q[9:8] == 2'd3) begin
            q <= 10'b0;
        end
        else begin
            q <= q + 1'b1;
        end
    end
end

endmodule