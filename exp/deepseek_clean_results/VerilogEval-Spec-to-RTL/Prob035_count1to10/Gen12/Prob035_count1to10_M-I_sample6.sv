module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0001;
    end
    else begin
        if (q[3]) begin          // Simplified wrap-around detection (only check q[3])
            q <= 4'b0001;
        end
        else if (q == 4'b1001) begin  // Special case for 9->10 transition
            q <= 4'b1010;
        end
        else begin
            q <= q + 1'b1;       // Normal increment
        end
    end
end

endmodule