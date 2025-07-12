module TopModule(
    input clk,
    input reset,
    output reg [9:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 10'd0; // reset counter to 0
    end else if (q == 10'd999) begin
        q <= 10'd0; // wrap around to 0
    end else begin
        q <= q + 1; // increment counter
    end
end

endmodule