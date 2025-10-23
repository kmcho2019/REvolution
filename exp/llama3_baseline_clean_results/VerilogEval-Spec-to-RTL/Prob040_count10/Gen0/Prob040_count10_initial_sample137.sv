module TopModule(
    input clk,
    input reset,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 4'd0; // reset to 0 when reset is high
    end else if (q == 4'd9) begin
        q <= 4'd0; // wrap around to 0 when count reaches 9
    end else begin
        q <= q + 1; // increment the count otherwise
    end
end

endmodule