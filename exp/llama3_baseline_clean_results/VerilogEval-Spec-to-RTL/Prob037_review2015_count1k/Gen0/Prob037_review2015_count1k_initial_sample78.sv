module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

always @ (posedge clk) begin
    if (reset) begin
        q <= 10'd0; // reset to 0 when reset is high
    end else if (q == 10'd999) begin
        q <= 10'd0; // reset to 0 when count reaches 999
    end else begin
        q <= q + 1; // increment count
    end
end

endmodule