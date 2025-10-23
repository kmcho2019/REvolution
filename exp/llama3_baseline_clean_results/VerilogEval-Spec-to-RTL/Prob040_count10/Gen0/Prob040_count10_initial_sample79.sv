module TopModule(
    input clk,
    input reset,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 4'd0; // reset to 0
    end else if (q == 4'd9) begin
        q <= 4'd0; // reset to 0 after counting to 9
    end else begin
        q <= q + 1; // increment counter
    end
end

endmodule