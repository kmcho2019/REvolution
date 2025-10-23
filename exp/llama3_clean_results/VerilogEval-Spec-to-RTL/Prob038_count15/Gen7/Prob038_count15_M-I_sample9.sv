module TopModule(
    input  clk,
    input  reset,
    output reg [3:0] q = 4'd0
);

always @(posedge clk) begin
    if (reset) begin
        q <= 4'd0;
    end else if (q == 4'd15) begin
        q <= 4'd0; // Explicitly handle wrap-around
    end else begin
        q <= q + 1; // Increment for all other values
    end
end

endmodule