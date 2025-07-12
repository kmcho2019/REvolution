module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

always @(posedge clk) begin
    if (a) begin
        q <= q;  // Hold value when a is high
    end else begin
        q <= (q == 3'd6) ? 3'd0 : q + 1;  // Increment and wrap around
    end
end

endmodule