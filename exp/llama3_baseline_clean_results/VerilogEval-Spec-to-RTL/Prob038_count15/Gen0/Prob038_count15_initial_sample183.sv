module TopModule(
    input clk,
    input reset,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 4'd0;  // reset the counter to 0
    end else begin
        q <= q + 1;  // increment the counter
    end
end

endmodule