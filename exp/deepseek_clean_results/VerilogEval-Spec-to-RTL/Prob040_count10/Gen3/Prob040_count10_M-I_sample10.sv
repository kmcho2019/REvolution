module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0000;
    end else begin
        q <= (q[3] & q[0]) ? 4'b0000 : q + 1;  // Check for 9 (1001) using just q[3] and q[0]
    end
end

endmodule