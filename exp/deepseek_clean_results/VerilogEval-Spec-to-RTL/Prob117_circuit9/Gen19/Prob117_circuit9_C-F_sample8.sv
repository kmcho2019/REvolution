module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

always @(posedge clk) begin
    if (a) begin
        q <= 3'd4;  // Priority override when a=1
    end else begin
        // Arithmetic increment with wrap-around
        q <= (q == 3'd6) ? 3'd0 : q + 1;
    end
end

endmodule