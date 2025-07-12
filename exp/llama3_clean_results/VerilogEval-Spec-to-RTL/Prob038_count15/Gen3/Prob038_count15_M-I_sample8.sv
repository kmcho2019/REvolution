module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 4'd0;
    end else if (q == 4'd15) begin // Reset the counter after reaching 15
        q <= 4'd0;
    end else begin
        q <= q + 1'd1;
    end
end

endmodule