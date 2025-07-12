module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0000;
    end
    else begin
        if (q == 4'b1001) begin  // Clear when reaching 9
            q <= 4'b0000;
        end
        else begin
            q <= q + 1'b1;      // Normal increment
        end
    end
end

endmodule