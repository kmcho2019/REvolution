module TopModule(
    input clk,
    input reset,
    output [3:0] q
);

reg [3:0] q;

always @(posedge clk) begin
    if (reset) begin
        q <= 4'd0; // reset q to 0 if reset is high
    end else begin
        q <= q + 4'd1; // increment q by 1 if reset is low
    end
end

endmodule