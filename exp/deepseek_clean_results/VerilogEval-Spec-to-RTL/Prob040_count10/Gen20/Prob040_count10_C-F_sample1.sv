module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

parameter WIDTH = 4;
parameter MAX_COUNT = 9;

always @(posedge clk) begin
    if (reset) begin
        // Synchronous reset to 0
        q <= {WIDTH{1'b0}};
    end else begin
        // Efficient rollover detection (9 = 1001)
        if (q[3] & q[0]) begin
            q <= {WIDTH{1'b0}};
        end else begin
            // Normal increment
            q <= q + 1'b1;
        end
    end
end

endmodule